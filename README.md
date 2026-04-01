ForkDash — Food Ordering Web Application

A full-stack food ordering web application built with **Java Servlets, JSP, and MySQL** following the **DAO Design Pattern**. Features role-based access control for Customers, Restaurant Admins, and Delivery Agents.


# Live Flow

Customer → Browse Restaurants → View Menu → Add to Cart → Checkout → Order Placed
Restaurant Admin → View Orders → Update Status (Preparing → Ready)
Delivery Agent → Accept Order → Mark as Delivered


# Features

Customer
- Register and login with role-based authentication
- Browse 20+ restaurants with cuisine filters
- View full menu for each restaurant
- Add items to cart (single restaurant at a time)
- Increase / decrease / remove items from cart
- Checkout with delivery address and phone
- Order confirmation with order ID

Restaurant Admin
- Dedicated dashboard after login
- View restaurant details
- View and manage menu items
- Add new menu items
- View incoming orders in real time
- Update order status → Preparing → Ready

Delivery Agent
- View all orders ready for pickup
- Accept a delivery
- Mark order as Delivered
- View personal delivery history


# Tech Stack

| Layer          | Technology |

| Frontend       | HTML, CSS, JSP |
| Backend        | Java Servlets |
| Database       | MySQL |
| Server         | Apache Tomcat 10.1 |
| Architecture   | DAO Design Pattern |
| Java Version   | Java 21 |
| IDE            | Eclipse |



# Project Structure

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



# Database Schema

sql
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


# How to Run

Prerequisites
- Java 21
- Apache Tomcat 10.1
- MySQL 8.0
- Eclipse IDE (Dynamic Web Project)

# Steps

1. Clone the repository**
git clone https://github.com/Komal2004-2006/ForkDash_FoodDeliveryApp.git

2. Import into Eclipse**
File → Import → Existing Projects into Workspace → Select folder

3. Set up MySQL
- Create database: `CREATE DATABASE signup;`
- Run the schema SQL above
- Insert restaurants data

**4. Configure DB connection**

Open src/com/tap/util/DBUtil.java and update:
java
private static final String URL  = "jdbc:mysql://localhost:3306/swisshy";
private static final String USER = "root";
private static final String PASS = "your_password";  // ← change this


5. Add MySQL connector JAR
- Download mysql-connector-j.jar
- Place in WebContent/WEB-INF/lib/

6. Deploy to Tomcat
Right-click project → Run As → Run on Server → Apache Tomcat 10.1

7. Open in browser
http://localhost:8080/Swisshy/

# User Roles

| Role      | Default Redirect   | Access |
| `customer` | `/restaurant` | Browse, order food |
| `restaurant_admin` | `/restaurantAdmin` | Manage restaurant & orders |
| `delivery_agent` | `/delivery` | Accept & deliver orders |



# Pages

| Page | URL |
| Home | `/index.jsp` |
| Login | `/login.html` |
| Register | `/registration.html` |
| Restaurants | `/restaurant` |
| Menu | `/menu?restaurant=name` |
| Cart | `/cart` |
| Checkout | `/checkout` |
| Order Confirmation | `/orderConfirmation.jsp` |
| Restaurant Dashboard | `/restaurantAdmin` |
| Delivery Dashboard | `/delivery` |



# Development Timeline

| Session | Topic | Duration |
| Project 01 | DAO Design Pattern | 1 hr 20 min |
| Project 02 | DAO Implementation | 1 hr 25 min |
| Project 03 | RestaurantServlet & restaurant.jsp | 1 hr |
| Project 04 | MenuServlet & menu.jsp | 45 min |
| Project 05 | Cart.java, CartItem.java & CartServlet | 1 hr 5 min |
| Project 06 | CartServlet-1 | 54 min |
| Project 07 | cart.jsp & CartServlet-2 | 44 min |
| Project 08 | CheckoutServlet | 1 hr |
| Project 09 | GitHub Upload | - |

# Author

Komal — Java Full Stack Developer (Learning)


# License

This project is for educational purposes.
