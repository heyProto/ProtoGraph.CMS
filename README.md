<%= content_for :page_title do %>
    
        
        <li class="breadcrumb-item active" aria-current="page">Page Builder</li>
      
<% end %>

<div class="row">
    <div class="col-sm-13">
        <div style="margin-left: auto; margin-right: auto; width: 500px;">
        </div>
    </div>
	<div class="col-sm-3 help-text">
		<!--<%= image_tag "help.png", style: "float: right; right: 0; top: 0; position: relative;" %><h2>Email Settings</h2>
		<p>Your default support email address is prototype@pro.to. Any email sent here gets automatically converted into a ticket that you can get working on.</p>
		<p>You can configure your Freshdesk account to use a support email in your own domain, like <a href="">support@mycompany.com</a> by forwarding emails from this address to <a href="">protoprototype@heyproto.freshdesk.com</a>. To create a new support email box, click “Edit” under global email settings.</p>-->
	</div>
</div>


- Set a global_slug in each template. Same method to remove spaces from username.

Create VERSIONS
- Carry forward proprerties.

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

Multiple email ID support -- rails g scaffold user_emails user_id:integer email:string token:string confirmation_sent_at:datetime accepted_at:datetime

* Add a Pykih user in all accounts. Hide him.