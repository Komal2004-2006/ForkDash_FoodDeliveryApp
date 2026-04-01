# ForkDash_FoodDeliveryApp
ForkDash is a food ordering web app developed using Core Java,  Servlets, JSP, and MySQL following the DAO Design Pattern. Customers can browse restaurants, view menus, add items to cart,  and place orders. Restaurant Admins can manage their menu and  update order statuses. Delivery Agents can accept and deliver orders. 

Layer           Technology
1) Backend         Java Servlets (Jakarta EE)
2) Frontend        JSP, HTML, CSS
3) Database        MySQL
4) Server          Apache Tomcat 10.1
5) IDE             Eclipse
6) Architecture    DAO Design Pattern

Customer:
* Register and login with role-based access
* Browse 20+ restaurants with cuisine filters
* View full menu for each restaurant
* Add items to cart (single restaurant at a time)
* Checkout with delivery address and phone
* Order confirmation with order ID

Restaurant Admin:
* View restaurant details
* Manage menu items (view + add)
* View incoming orders in real time
* Update order status: Placed → Preparing → Ready

Delivery Agent:
* View all orders ready for pickup
* Accept a delivery
* Mark orders as Delivered
* View delivery history

PROJECT STRUCTURE:
Swisshy/
│
├── src/
│   └── com/
│       └── tap/
│           ├── model/
│           │   ├── User.java
│           │   ├── Restaurant.java
│           │   ├── MenuItem.java
│           │   ├── Cart.java
│           │   └── CartItem.java
│           │
│           ├── dao/
│           │   ├── UserDAO.java
│           │   ├── RestaurantDAO.java
│           │   └── MenuDAO.java
│           │
│           ├── daoimpl/
│           │   ├── UserDAOImpl.java
│           │   ├── RestaurantDAOImpl.java
│           │   └── MenuDAOImpl.java
│           │
│           ├── servlet/
│           │   ├── loginServlet.java
│           │   ├── RegistrationServlet.java
│           │   ├── RestaurantServlet.java
│           │   ├── MenuServlet.java
│           │   ├── CartServlet.java
│           │   ├── CheckoutServlet.java
│           │   ├── RestaurantAdminServlet.java
│           │   ├── DeliveryServlet.java
│           │   └── logoutServlet.java
│           │
│           └── util/
│               ├── DBUtil.java
│               └── AppContextListener.java
│
└── WebContent/
    ├── WEB-INF/
    │   ├── web.xml
    │   └── lib/
    │       └── mysql-connector-j.jar
    │
    ├── index.jsp
    ├── login.html
    ├── registration.html
    ├── restaurant.jsp
    ├── menu.jsp
    ├── cart.jsp
    ├── checkout.jsp
    ├── orderConfirmation.jsp
    ├── restaurantDashboard.jsp
    ├── delivery.jsp
    ├── addRestaurant.html
    └── addMenu.html

DATABASE SCHEMA:
-- Users
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    uname         VARCHAR(100),
    uemail        VARCHAR(100) UNIQUE,
    upwd          VARCHAR(255),
    uphonenumber  VARCHAR(15),
    role          VARCHAR(20) DEFAULT 'customer'
);

-- Restaurants
CREATE TABLE restaurants (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100),
    cuisine      VARCHAR(100),
    location     VARCHAR(200),
    image_url    VARCHAR(300),
    owner_id     INT,
    rating       VARCHAR(10),
    eta          VARCHAR(20),
    description  TEXT,
    offer        VARCHAR(100)
);

-- Menu Items
CREATE TABLE menu (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    restaurant  VARCHAR(100),
    item_name   VARCHAR(100),
    description TEXT,
    price       DOUBLE,
    category    VARCHAR(100)
);

-- Orders
CREATE TABLE orders (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    user_id             INT,
    user_name           VARCHAR(100),
    total               DOUBLE,
    address             VARCHAR(300),
    phone               VARCHAR(20),
    status              VARCHAR(50) DEFAULT 'Placed',
    restaurant_name     VARCHAR(100),
    delivery_agent_id   INT,
    delivery_agent_name VARCHAR(100),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Items
CREATE TABLE order_items (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT,
    item_name  VARCHAR(100),
    restaurant VARCHAR(100),
    price      DOUBLE,
    quantity   INT
);

How to Run:
*Prerequisites
Java 21
Apache Tomcat 10.1
MySQL 8.0
Eclipse IDE (Dynamic Web Project)

Steps
1. Clone the repository
git clone https://github.com/yourusername/forkdash.git

2. Import into Eclipse
File → Import → Existing Projects into Workspace → Select folder

3. Set up MySQL

Create database: CREATE DATABASE swisshy;
Run the schema SQL above
Insert restaurants data

4. Configure DB connection
Open src/com/tap/util/DBUtil.java and update:
private static final String URL  = "jdbc:mysql://localhost:3306/swisshy";
private static final String USER = "root";
private static final String PASS = "your_password";  // ← change this

5. Add MySQL connector JAR
Download mysql-connector-j.jar
Place in WebContent/WEB-INF/lib/

6. Deploy to Tomcat
Right-click project → Run As → Run on Server → Apache Tomcat 10.1

7. Open in browser
http://localhost:8080/Swisshy/

Page                    URL
Home                  /index.jsp
Login                 /login.html
Register              /registration.html
Restaurants           /restaurant
Menu                  /menu?restaurant=name
Cart                  /cart 
Checkout              /checkout
Order Confirmation    /orderConfirmation.jsp
Restaurant Dashboard  /restaurantAdmin
DeliveryDashboard     /delivery

Author
Komal — Java Full Stack Developer (Learning)

 License
This project is for educational purposes.

