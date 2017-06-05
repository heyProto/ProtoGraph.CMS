* Add a Pykih user in all accounts. Hide him.

* Authentications can be deleted

- Registrations > If someone signs up with an email ID that matches XYZ then it will automatically add him to that platform.

Test out roles scoping

Permission can be deactivated.
Change global sudos to check only for ACTIVATED permissions.

------------------------------------------------------------------------------------

- Set a global_slug in each template. Same method to remove spaces from username.

- Move SHOW page to EDIT page.
--- TS
--- TC
--- TD

- Show of TemplateStreams
--- Attach Cards
--- can_delete? of TemplateStreamCards

3. Delete or Deactivate button on
- TemplateData
- TemplateCard
- TempalteStream

Improve UI of Template Designer
- Index
- Edit

4. Upload forms
- Decide CDN Folder Name Structures
- Upload images

------------------------------------------------------------------------------------

Write clean documentation

------------------------------------------------------------------------------------

Shopping site for cards

------------------------------------------------------------------------------------

Streams to create
- One card stream
- Image Gallery

Cards to create
- Text
- Quote
- Image
- Video - YouTube link
- Explainer

Streamline sign up / sign in - Can it become oAuth?

Search Engine
TemplateCards -- platforms, sizes

Admin pages

Public Activity

Multiple email ID support

rails g scaffold user_emails user_id:integer email:string token:string confirmation_sent_at:datetime accepted_at:datetime
