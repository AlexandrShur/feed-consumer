var myHeaders = new Headers();
myHeaders.set('Cache-Control', 'no-store');
var urlParams = new URLSearchParams(window.location.search);
var tokens;
var domain = "variable_to_replace_provider_domain_id";
var region = "variable_to_replace_aws_region";
var appClientId = "variable_to_replace_client_id";
var appClientSecret = "variable_to_replace_client_secret";
var userPoolId = "variable_to_replace_user_pool_id";
var redirectURI = "variable_to_replace_domain_url";
var host = redirectURI + "/"
var apiURI = "variable_to_replace_api_endpoint/rss"

//Convert Payload from Base64-URL to JSON
const decodePayload = payload => {
  const cleanedPayload = payload.replace(/-/g, '+').replace(/_/g, '/');
  const decodedPayload = atob(cleanedPayload)
  const uriEncodedPayload = Array.from(decodedPayload).reduce((acc, char) => {
    const uriEncodedChar = ('00' + char.charCodeAt(0).toString(16)).slice(-2)
    return `${acc}%${uriEncodedChar}`
  }, '')
  const jsonPayload = decodeURIComponent(uriEncodedPayload);

  return JSON.parse(jsonPayload)
}

//Parse JWT Payload
const parseJWTPayload = token => {
    const [header, payload, signature] = token.split('.');
    const jsonPayload = decodePayload(payload)

    return jsonPayload
};

//Parse JWT Header
const parseJWTHeader = token => {
    const [header, payload, signature] = token.split('.');
    const jsonHeader = decodePayload(header)

    return jsonHeader
};

//Generate a Random String
const getRandomString = () => {
    const randomItems = new Uint32Array(28);
    crypto.getRandomValues(randomItems);
    const binaryStringItems = randomItems.map(dec => `0${dec.toString(16).substr(-2)}`)
    return binaryStringItems.reduce((acc, item) => `${acc}${item}`, '');
}

//Encrypt a String with SHA256
const encryptStringWithSHA256 = async str => {
    const PROTOCOL = 'SHA-256'
    const textEncoder = new TextEncoder();
    const encodedData = textEncoder.encode(str);
    return crypto.subtle.digest(PROTOCOL, encodedData);
}

//Convert Hash to Base64-URL
const hashToBase64url = arrayBuffer => {
    const items = new Uint8Array(arrayBuffer)
    const stringifiedArrayHash = items.reduce((acc, i) => `${acc}${String.fromCharCode(i)}`, '')
    const decodedHash = btoa(stringifiedArrayHash)

    const base64URL = decodedHash.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    return base64URL
}

function updatePage() {
	window.location.href = redirectURI;
}

async function getRssSettings() {

    await fetch(apiURI,{
      method: 'get',
      headers: {
        'authorization': 'Bearer ' + sessionStorage.getItem("access_token")
    }})
    .then((response) => {
      return response.json();
    })
    .then((data) => {

	  if (data.length == 0) {
		  document.getElementById("rss_settings").appendChild(document.createTextNode("No saved data."))
	  } else {
		  data.forEach(item => {
			item  = JSON.parse(item);
			const record = document.createElement("div");
			record.style.marginTop = "10px";
			
			const label = document.createElement("div");
			const sourcesName = document.createTextNode("Name: " + item.name);
			label.appendChild(sourcesName);
			
			const content = document.createElement("div");
			content.style.display = "inline-grid"; 
			content.appendChild(document.createTextNode("Sources: "));
			item.sources.forEach(link => {
				var a = document.createElement('a');
				a.setAttribute('href', link);
				a.innerHTML = link;
				content.appendChild(a);
			});
			
			const rssData = document.createElement("div");
			const rssLink = document.createElement('a');
			rssLink.setAttribute('href', host + item.rssLink);
			rssLink.innerHTML = host + item.rssLink;
			rssData.appendChild(document.createTextNode("Feed link: "));
			rssData.appendChild(rssLink);
			
			record.appendChild(label);
			record.appendChild(content);
			record.appendChild(rssData);
			document.getElementById("rss_settings").appendChild(record);
		  });
	  }
      
    });
}

async function setRssSettings() {
	
	let source = {};
	source.name = document.getElementById("source_name").value;
	source.sources = document.getElementById("sources").value.split("\n");

    await fetch(apiURI,{
      method: 'post',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'authorization': 'Bearer ' + sessionStorage.getItem("access_token")
      },
	  body: JSON.stringify(source)
	})
    .then((response) => {
	  return response.text();
    })
    .then((data) => {
	  document.getElementById("new_rss_url_label").style.display = "block"; 
	  let el = document.getElementById("new_rss_url");
	  el.style.display = "block"; 
	  if (data.includes('feed')) {
		el.innerHTML = host + data;
	  } else {
		el.innerHTML = data;
	  } 
    });
}

// Main Function.
async function main() {
  var code = urlParams.get('code');
  //If code not present then request code else request tokens
  if (code == null){

    // Create random "state"
    var state = getRandomString();
    sessionStorage.setItem("pkce_state", state);

    // Create PKCE code verifier
    var code_verifier = getRandomString();
    sessionStorage.setItem("code_verifier", code_verifier);

    // Create code challenge
    var arrayHash = await encryptStringWithSHA256(code_verifier);
    var code_challenge = hashToBase64url(arrayHash);
    sessionStorage.setItem("code_challenge", code_challenge)

    // Redirtect user-agent to /authorize endpoint
    location.href = "https://"+domain+".auth."+region+".amazoncognito.com/oauth2/authorize?response_type=code&state="+state+"&client_id="+appClientId+"&client_secret="+appClientSecret+"&redirect_uri="+redirectURI+"&scope=openid&code_challenge_method=S256&code_challenge="+code_challenge;
  } else {

    // Verify state matches
    state = urlParams.get('state');
    if(sessionStorage.getItem("pkce_state") != state) {
        alert("Invalid state");
    } else {

    // Fetch OAuth2 tokens from Cognito
    code_verifier = sessionStorage.getItem('code_verifier');
  await fetch("https://"+domain+".auth."+region+".amazoncognito.com/oauth2/token?grant_type=authorization_code&client_id="+appClientId+"&client_secret="+appClientSecret+"&code_verifier="+code_verifier+"&redirect_uri="+redirectURI+"&code="+ code,{
  method: 'post',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  }})
  .then((response) => {
    return response.json();
  })
  .then((data) => {

    // Verify id_token
    tokens=data;
    var idVerified = verifyToken (tokens.id_token);
    Promise.resolve(idVerified).then(function(value) {
      if (value.localeCompare("verified")){
        alert("Invalid ID Token - "+ value);
        return;
      }
      });
    sessionStorage.setItem("id_token", tokens.id_token);
	sessionStorage.setItem("access_token", tokens.access_token);
	getRssSettings();
  });

}}}
main();
  
  