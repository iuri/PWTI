<master>
<h1>Converting a set of pages into using formtemplate</h1>
This page show how to convert a set of pages that doesn't use formtemplate into using formtemplate
<br><br>
<ol>
<li>Let's take this simple form (let's say it's called form.adp) :
<br>
<pre>
&lt;form method="post" name="news" action="item-create-2"&gt;
	&lt;table&gt;
	&lt;tr&gt;
		&lt;td&gt;Title&lt;/td&gt;
		&lt;td&gt;&lt;input type="text" size="51" maxlength="400" id="publish_title" name=publish_title value="\@publish_title\@"&gt;&lt;/td&gt;
	&lt;/tr&gt;

	&lt;tr&gt;
		&lt;td&gt;Lead&lt;/td&gt;
		&lt;td&gt;&lt;textarea id="publish_lead" name=publish_lead cols=50 rows=3&gt;\@publish_lead\@&lt;/textarea&gt;&lt;/td&gt;
	&lt;/tr&gt;

	&lt;tr&gt;
		&lt;td&gt;Body *&lt;/td&gt;
		&lt;td&gt;&lt;textarea id="publish_body" name=publish_body cols=50 rows=20  wrap=soft&gt;\@publish_body\@&lt;/textarea&gt;&lt;/td&gt;
	&lt;/tr&gt;

	&lt;tr&gt;
		&lt;td&gt;&lt;/td&gt;
		&lt;td align="left"&gt;&lt;input type=submit value="Submit"&gt;&lt;/td&gt;
	&lt;/tr&gt;
&lt;/form&gt;
</pre>
</li>
<li> Now what's wrong with this form? NOTHING! Then why do we need to switch to using formtemplate? Because formtemplate
	offers us several advantages. 
	<ul>
	<li>
	<li>
	</ul>
<li> Let's examine how to use ad_form.
<li> Using formtemplate consists of two main components:
	<ul>	
	<li>The &lt;formtemplate&gt; tag in the adp page
	<li>The ad_form procedure
	</ul>
<li> To replicate the above form using formtemplate, we do the following:
	<ul>
	<li>Modify/create form.tcl and use ad_form to define the widgets using ad_form
	<li>To replicate the above form, the call to ad_form would look like:
	<li>
<pre>
ad_form -name news -method post -form {
	{story_id:key(acs_object_id_seq)}
	{publish_title
publish_lead
publish_body
submit:
}	
</pre>
	<li>Then modify the adp page (form.adp) and get rid of everything between &lt;form&gt; and &lgt;/form&gt; including the form tags themselves.
	<li>Now add the following to form.adp:
<pre>
&lt;formtemplate id=news&gt;&lt;/formtemplate&gt;
</pre>
	<li>Voila, your initial form is now set up. 
	</ul>
<li> Now we need to think about submitting to the database.
<li> For files that don't use ad_form, the form usually submits to a different page. <br>
	Using formtemplate eliminates this.  Most pages that use formtemplate will just submit back to the same page. 
	One of the main advantages of submitting back to the same page is that you can get inline error messages in the form.

</ol>