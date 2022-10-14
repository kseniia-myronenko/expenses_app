# Expenses Counting App
<div style="display: flex;">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/kseniia-myronenko/expenses_app">
<img alt="GitHub all releases" src="https://img.shields.io/github/downloads/kseniia-myronenko/expenses_app/total">
</div>
<div style="display: flex;">
<img src="https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white" />
<img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" />
</div><br>
<p>This is the app for spending counting. User can: create/edit/delete spendings, create/edit/delete categories for different type of spendings.</p>
<p>There is provided possibility to filter all spendings by category, min/max amount and sorting by amount, check total sum of spendings.</p>
<p>Users can share their total spending list with other registered members.</p>

<h2>Configuration</h2>

<ol>
<li><b>Ruby:</b> 3.1.2</li>
<li><b>Rails:</b> ~> 7.0.3</li>
<li><b>Database:</b> PostgreSQL</li>
</ol>

<h2>Run app</h2>
<ol>
<li>Setup gems & database:</li>
<pre>
bundle install<br>
rails db:create<br>
rails db:migrate<br>
rails db:seed
</pre>
<li>Project is provided with models and requests tests. Run tests with <code>rspec</code> command in console. Also you will see test coverage.</li>
</ol>
<h2>Use case</h2>
<ol>
<li>If you want to watch account with predefined data, run <code>rails db:seed</code>. Login to the system with credentials <code> Dave19</code> ans password <code>pa$$word</code>. You can also sign up to the system, but there will be no predefined categories as there is possibility for users to create their own categories.</li>
<li>Start server<code>rails s</code></li>
<li>On the main page you will see three blocks such as "Create spending", "Watch all spendings" and "Create category". User can add descriptions to the spendings and categories.</li>
<li>On the all spengings page <code>localhost:3000/users/:user_id/spendings</code> you can sort spendings by different attributes. Also you can share this page with registered users.<br>
Note, that after push "Filter" button you will see the result of request, but params will not be saved to the fields.</li>
</ol>
