**XMediusSENDSECURE (SendSecure)** is a collaborative file exchange platform that is both highly secure and simple to use.
It is expressly designed to allow for the secured exchange of sensitive documents via virtual SafeBoxes.

SendSecure comes with a **Web API**, which is **RESTful**, uses **HTTPs** and returns **JSON**.

Specific libraries have been published for various languages:
[C#](https://github.com/xmedius/sendsecure-csharp),
[Java](https://github.com/xmedius/sendsecure-java),
[JavaScript](https://github.com/xmedius/sendsecure-js),
[PHP](https://github.com/xmedius/sendsecure-php),
[Python](https://github.com/xmedius/sendsecure-python)
and
**Ruby**.

# sendsecure-ruby

**This library allows you to use the SendSecure Web API via Ruby.**

With this library, you will be able to:
* Authenticate SendSecure users
* Create new SafeBoxes

# Table of Contents

* [Installation](#installation)
* [Quick Start](#quickstart)
* [Usage](#usage)
* [License](#license)
* [Credits](#credits)

<a name="installation"></a>
# Installation

## Prerequisites

- Ruby version 2.1+
- The SendSecure service, provided by [XMedius](https://www.xmedius.com/en/products?source=sendsecure-ruby) (demo accounts available on demand)

## Install Package

```ruby
gem build sendsecure-ruby.gemspec
gem install sendsecure-ruby-1.0.0.gem
```

<a name="quickstart"></a>
# Quick Start

## Authentication (Retrieving API Token)

Authentication is done using an API Token, which must be first obtained based on SendSecure enterprise account and user credentials.
Here is the minimum code to get such a user-based API Token.

```ruby
require 'sendsecure-ruby'

token = SendSecure::Client.get_user_token("deathstar", "darthvader", "d@Rk$1De", "DV-TIE/x1", "TIE Advanced x1", "The Force App", "https://portal.xmedius.com")
```

## SafeBox Creation (Using SafeBox Helper Class)

Here is the minimum required code to create a SafeBox – with 1 recipient, a subject, a message and 1 attachment.
This example uses the user's *default* security profile (which requires to be set in the account).

```ruby
require 'sendsecure-ruby'

user_email = "darthvader@empire.com"
token = "USER|1d495165-4953-4457-8b5b-4fcf801e621a"
enterprise_account = "deathstar"
endpoint = "https://portal.xmedius.com"

client = SendSecure::Client.new(token, enterprise_account, endpoint)

sb = SendSecure::SafeBox.new({user_email:user_email, notification_language:"en"})
sb.subject = "Family matters"
sb.message = "Son, you will find attached the evidence."

recipient = SendSecure::Recipient.new({email:"lukeskywalker@rebels.com"}) 
recipient.contact_methods << SendSecure::ContactMethod.new({destination_type:"cell_phone", destination:"555-232-5334"})
sb.recipients << recipient

sb.attachments << SendSecure::Attachment.new({file_path:"path/to/Birth_Certificate.pdf", content_type:"application/pdf"})

response = client.submit_safebox(sb)
```

<a name="usage"></a>
# Usage

## Helper Methods

### Get User Token
```
get_user_token(enterprise_account, username, password, device_id, device_name, application_type, endpoint, one_time_password)
```
Creates and returns an API Token for a specific user within a SendSecure enterprise account.
Calling this method again with the exact same params will always return the same Token.

Param              | Definition
-------------------|-----------
enterprise_account | The SendSecure enterprise account
username           | The username of a SendSecure user of the current enterprise account
password           | The password of this user
device_id          | The unique ID of the device used to get the Token 
device_name        | The name of the device used to get the Token
application_type   | The type/name of the application used to get the Token ("SendSecure Ruby" will be used by default if empty)
endpoint           | The URL to the SendSecure service ("https://portal.xmedius.com" will be used by default if empty)
one_time_password  | The one-time password of this user (if any)

### Client Object Constructor
```
initialize(api_token, enterprise_account, endpoint, locale)
```

Param              | Definition
-------------------|-----------
api_token          | The API Token to be used for authentication with the SendSecure service
enterprise_account | The SendSecure enterprise account
endpoint           | The URL to the SendSecure service ("https://portal.xmedius.com" will be used by default if empty)
locale             | The locale in which the server errors will be returned ("en" will be used by default if empty)

### Get Enterprise Settings
```
enterprise_settings
```
Returns all values/properties of the enterprise account's settings specific to SendSecure.

### Get Default Security Profile
```
default_security_profile(user_email)
```
Returns the default security profile (if it has been set) for a specific user, with all its setting values/properties.

Param      | Definition
-----------|-----------
user_email | The email address of a SendSecure user of the current enterprise account

### Get Security Profiles
```
security_profiles(user_email)
```
Returns the list of all security profiles available to a specific user, with all their setting values/properties.

Param      | Definition
-----------|-----------
user_email | The email address of a SendSecure user of the current enterprise account

### Initialize SafeBox
```
initialize_safebox(safebox)
```
Pre-creates a SafeBox on the SendSecure system and returns the updated [Safebox](#safebox) object with the necessary system parameters filled out (GUID, public encryption key, upload URL).

Param      | Definition
-----------|-----------
safebox    | A [Safebox](#safebox) object to be initialized by the SendSecure system

### Upload Attachment
```
upload_attachment(safebox, attachment)
```
Uploads the specified file as an Attachment of the specified SafeBox and returns the updated [Attachment](#attachment) object with the GUID parameter filled out.

Param       | Definition
------------|-----------
safebox     | An initialized [Safebox](#safebox) object
attachment  | An [Attachment](#attachment) object - the file to upload to the SendSecure system

### Commit SafeBox
```
commit_safebox(safebox)
```
Finalizes the creation (commit) of the SafeBox on the SendSecure system.
This actually "Sends" the SafeBox with all content and contact info previously specified.

Param      | Definition
-----------|-----------
safebox    | A [Safebox](#safebox) object already initialized, with security profile, recipient(s), subject and message already defined, and attachments already uploaded. 

### Submit SafeBox
```
submit_safebox(safebox)
```
This method is a high-level combo that initializes the SafeBox, uploads all attachments and commits the SafeBox.

Param      | Definition
-----------|-----------
safebox    | A non-initialized [Safebox](#safebox) object with security profile, recipient(s), subject, message and attachments (not yet uploaded) already defined. 


## Helper Modules

<a name="safebox"></a>
### Safebox

Builds an object to send all the necessary information to create a new Safebox.

Attribute             | Definition
----------------------|-----------
guid                  | The unique identifier of the SafeBox (filled by the system once the SafeBox is initialized).
upload_url            | The URL used to upload the SafeBox attachments (filled by the system once the SafeBox is initialized).
public_encryption_key | The key used to encrypt the SafeBox attachments and/or messages (filled by the system once the SafeBox is initialized).
user_email            | The email address of the creator of the SafeBox (mandatory).
subject               | The subject of the SafeBox (optional).
message               | The initial message of the SafeBox (optional if the SafeBox has at least one attachment).
recipients            | The list of all [Recipient](#recipient) objects of the SafeBox (mandatory, at least one recipient).
attachments           | The list of all [Attachment](#attachment) objects of the SafeBox (optional if the SafeBox has a message).
security_profile_id   | The SecurityProfile object defining security options for the SafeBox (mandatory).
notification_language | The language used for email notifications sent to the recipients (mandatory).

### SafeboxResponse

Represents the response to the successful creation of a SafeBox in the SendSecure system.
All attributes are filled by the system once the SafeBox is successfully created (sent).

Attribute            | Definition
---------------------|-----------
guid                 | The unique identifier of the SafeBox.
preview_url          | The URL to access the SafeBox in the SendSecure Web Portal.
encryption_key       | The key that may be required to decrypt the SafeBox content (only if Double Encryption is enabled in the Security Profile).

<a name="recipient"></a>
### Recipient

Builds an object to create a recipient for the SafeBox.

Attribute            | Definition
---------------------|-----------
email                | The email address of the recipient (mandatory).
first_name           | The first name of the recipient (optional).
last_name            | The last name of the recipient (optional).
company_name         | The company name of the recipient (optional).
contact_methods      | The list of all [ContactMethod](#contactmethod) objects of the recipient (may be mandatory depending on the Security Profile of the SafeBox).

<a name="contactmethod"></a>
### ContactMethod

Builds an object to create a phone number destination owned by the recipient (as part of the Recipient object attributes).
Any ContactMethod – plus the recipient's email address – will be usable as Security Code delivery means to the recipient.
All attributes are mandatory.

Attribute            | Definition
---------------------|-----------
destination          | A phone number owned by the recipient.
destination_type     | The phone number's type (i.e. home/cell/office/other).


<a name="attachment"></a>
### Attachment

Builds an object to be uploaded to the server as attachment of the SafeBox.
Can be created either with a [File Path](#filepath) or a [File](#file).
All attributes are mandatory.

<a name="filepath"></a>
#### File Path

Attribute            | Definition
---------------------|-----------
guid                 | The unique identifier of the attachment (filled by the system once the file is uploaded).
content_type         | The file Content-type (MIME). 
file_path            | The path (full filename) of the file to upload.

<a name="file"></a>
#### File

Attribute            | Definition
---------------------|-----------
guid                 | The unique identifier of the attachment (filled by the system once the file is uploaded).
content_type         | The file Content-type (MIME). 
file                 | The file object to upload.
filename             | The file name.

### SecurityProfile

Represents the settings of a Security Profile.
The use of specific attributes of this object rather takes place in advanced scenarios.
To know all available attributes, please look in the library.

### EnterpriseSettings

Represents the SendSecure settings of an Enterprise Account.
The use of specific attributes of this object rather takes place in advanced scenarios.
To know all available attributes, please look in the library.

### ExtensionFilter

Represents the list of allowed/forbidden extensions for SafeBox attachments (part of the EnterpriseSettings).
The use of specific attributes of this object rather takes place in advanced scenarios.
To know all available attributes, please look in the library.

<a name="license"></a>
# License

sendsecure-ruby is distributed under [MIT License](https://github.com/xmedius/sendsecure-ruby/blob/master/LICENSE).

<a name="credits"></a>
# Credits

sendsecure-ruby is developed, maintained and supported by [XMedius Solutions Inc.](https://www.xmedius.com?source=sendsecure-ruby)
The names and logos for sendsecure-ruby are trademarks of XMedius Solutions Inc.

![XMedius Logo](https://s3.amazonaws.com/xmc-public/images/xmedius-site-logo.png)
