4. Roles
- Add dropdown icon to CHANGE OF ROLE
- Permission can be deactivated
5. Authentications can be deleted.
- Add one pykih user to all ACCOUNTS

------

1. TemplateStreams Functionality
- Index
- Show
- New
- Public?
- Status Change

2. Show of TemplateStreams
- Attach Cards
- can_delete? of TemplateStreamCards

3. Delete or Deactivate button on
- TemplateData
- TemplateCard
- TempalteStream

6. Bring back concept of versions back in Templates
- rails g migration AddCols version:float previous_version_id:integer
- Change slug

Dependent Destroy
- Account cannot be deleted. Deactivated.

----

4. Upload forms
- Decide CDN Folder Name Structures
- Upload images

Shopping site for cards

----

Streams to create
- One card stream
- Image Gallery

Cards to create
- Text
- Quote
- Image
- Video - YouTube link
- Explainer

Associate a domain with an account
Permissions whether we want this to be added
Anyone who signs up with this domain then gets added to that account

Streamline sign up / sign in - Can it become oAuth?

Search Engine
TemplateCards -- platforms, sizes

Admin pages

Multiple email ID support

rails g scaffold user_emails user_id:integer email:string token:string confirmation_sent_at:datetime accepted_at:datetime

Public Activity

Create Account Show page
Test out roles scoping