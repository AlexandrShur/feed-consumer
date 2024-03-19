Environment requirements:
* Linux like OS (required because the deployment scripts use Linux commands like 'sed' and 'cp' to prepare UI files).
* Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
* Ready, google identity provider (docs/screenshot-0). You should specify there cognito redirect url.
Note: Please let me know if you have any issues with the setup.

Setup steps:
* Authentication.
* Update the `properties.tfvars` file with your custom AWS and Google provider settings.
* Run: terraform init
* Run: terraform apply -var-file properties.tfvars
* Use the output URL to access the created website (docs/screenshot-1).

How to use:
* Open web page.
* You should see a google authorization window.
* If the user is authorized, the web page will be displayed (docs/screenshot-2).

* UI Explanation:
** Under the label "Rss settings" the saved user data is displayed. If there is no data stored for the current user, the text "No stored data" should be displayed.
** Under the label "New rss from sources" items for creating new sources for RSS feeds are displayed.
*** Rss Name: here the user can specify the name of the new feed.
*** Sources: here the user can specify links to other feeds to be merged to one new feed.
Please note that each new link should start with a new line.
*** "Create new rss" button saves new sources. 

* Create new feed:
** Set a name and specify the sources as shown on (docs/screenshot-3).
Note: You can use the sources from (docs/feed_sources.txt).
** Press the "Create" button. (You should see a link to the new feed below the button.
Please note that feeds are updated every 20 minutes, so you will need to wait some time before this feed is available).
Press the "Reload Page" button to refresh the settings item data. (this is necessary because it is a simple HTML page and doesn't has dynamic elements update logic).
** When everything is done, you should see the saved settings under the label "Rss settings".

* Use the generated feed:
** You can find the link to it under "Rss settings" - "Feed link" or feed link that appears under the create button when the user clicks on it.

Architecture details:
* s3 is used as storage for the website, user source settings and generated feeds.
Cloudfront is used as a cache service. (The cache is updated every 5 minutes).
* 3 Lambdas:
** 1) reads user data from s3 (stored data has prefix ID, which is used to distinguish users. ID is taken from the token)
** 2) writes stored user preference data in json format. (s3 was used as storage because the format of settings is very easy to maintain and store).
** 3) Scheduler Lambda which goes through all the source settings and generates feeds based on the stored data.
Each generated feed is stored under a unique path (rss/{userId}/{feedNameSpecifiedByUser}/feed).
* Cognito uses to authenticate APIs that call lambdas.

Improvements (next improvements could be added to current deployment scripts, this depends on reviewer expectations):
* It was not mentioned in AC, but Cloudfront, Gateway API's and Cognito Auth Server could be moved under one domain.
* Currently already created feeds could be used as sources for new feeds. Actually, this is a bug:)
* Replacing the current UI with a React or Angular framework that uses the Amplify lib.
* Currently RSS generation is only run by scheduler, so it can be run when the user saves new data.
* Using a database instead of s3 to store feed source settings.

Note:
For variables, '"${var.id}"' was used instead of 'var.id' because it was easy for the author to work with such variables in the files.