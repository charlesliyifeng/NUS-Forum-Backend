# NUS-Forum-Backend

First Name: Yifeng  
Last Name: Li

This is the backend of NUS-Forum.
  
Note: this is the main (development) branch, so you can only run the app in development mode locally with  the frontend in development mode as well.  

Also note that the development branch uses sqlite, but the production branch uses postgresql.

To see the code for the deployed version, switch to the production branch.

## Getting Started

### Installation
1. Install Ruby on Rails

### Running the app

1. Install dependencies for the project by entering this command:

```bash
bundle install
```

2. Database creation

```bash
rails db:create
rails db:migrate
```

3. Database initialization

```bash
rails db:seed
```

4. Start the app by entering this command:

```bash
rails s
```

4. Open [http://localhost:3000](http://localhost:3000) to view it in the browser.
