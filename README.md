# Spring Boot 3 + GraphQL Demo Application

Ứng dụng demo GraphQL với Spring Boot 3, tích hợp JPA, H2 Database và JSP views.

## Tính năng

### Database Schema
- **User**: id, fullname, email, password, phone
- **Category**: id, name, images  
- **Product**: id, title, quantity, desc, price, userid

### Quan hệ
- Product → User (nhiều sản phẩm thuộc về 1 user)
- Category ↔ User (quan hệ many-to-many)

### GraphQL API Features
1. **Hiển thị tất cả product có price từ thấp đến cao**
2. **Lấy tất cả product của 1 category**
3. **CRUD operations** cho User, Product, Category
4. **Quản lý quan hệ** User-Category

## Cài đặt và chạy

### Prerequisites
- Java 17+
- Maven 3.6+

### Chạy ứng dụng
```bash
mvn spring-boot:run
```

### Truy cập ứng dụng
- **Web Interface**: http://localhost:8080
- **GraphQL Playground**: http://localhost:8080/graphiql
- **H2 Console**: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:testdb`
  - Username: `sa`
  - Password: (để trống)

## GraphQL Queries Examples

### 1. Lấy tất cả sản phẩm theo giá tăng dần
```graphql
query {
  productsByPriceAsc {
    id
    title
    price
    user {
      fullname
    }
  }
}
```

### 2. Lấy sản phẩm theo category
```graphql
query {
  productsByCategory(categoryId: 1) {
    id
    title
    price
    desc
    user {
      fullname
    }
  }
}
```

### 3. Tạo user mới
```graphql
mutation {
  createUser(input: {
    fullname: "John Doe"
    email: "john@example.com"
    password: "password123"
    phone: "0123456789"
  }) {
    id
    fullname
    email
  }
}
```

### 4. Tạo product mới
```graphql
mutation {
  createProduct(input: {
    title: "New Product"
    quantity: 10
    desc: "Product description"
    price: 99.99
    userId: 1
  }) {
    id
    title
    price
    user {
      fullname
    }
  }
}
```

### 5. Thêm user vào category
```graphql
mutation {
  addUserToCategory(userId: 1, categoryId: 1)
}
```

## Web Interface Features

### 1. Products Page (/products)
- Hiển thị tất cả sản phẩm
- Sắp xếp theo giá (thấp đến cao)
- Lọc theo category
- Thêm sản phẩm mới
- Xóa sản phẩm

### 2. Users Page (/users)  
- Quản lý users
- Hiển thị categories và products của từng user
- Thêm/xóa user

### 3. Categories Page (/categories)
- Quản lý categories
- Quản lý quan hệ user-category
- Thêm/xóa category

## Cấu trúc Project

```
src/
├── main/
│   ├── java/vn/iotstar/
│   │   ├── BTGraphQLApplication.java
│   │   ├── config/
│   │   │   ├── DataLoader.java
│   │   │   └── GraphQLConfig.java
│   │   ├── controller/
│   │   │   ├── GraphQLController.java
│   │   │   └── WebController.java
│   │   ├── dto/
│   │   │   ├── CategoryInput.java
│   │   │   ├── CategoryUpdateInput.java
│   │   │   ├── ProductInput.java
│   │   │   ├── ProductUpdateInput.java
│   │   │   ├── UserInput.java
│   │   │   └── UserUpdateInput.java
│   │   ├── entity/
│   │   │   ├── Category.java
│   │   │   ├── Product.java
│   │   │   └── User.java
│   │   ├── repository/
│   │   │   ├── CategoryRepository.java
│   │   │   ├── ProductRepository.java
│   │   │   └── UserRepository.java
│   │   └── service/
│   │       ├── CategoryService.java
│   │       ├── ProductService.java
│   │       └── UserService.java
│   ├── resources/
│   │   ├── application.properties
│   │   └── graphql/
│   │       └── schema.graphqls
│   └── webapp/WEB-INF/views/
│       ├── index.jsp
│       ├── products.jsp
│       ├── users.jsp
│       └── categories.jsp
└── pom.xml
```

## Sample Data

Ứng dụng tự động load sample data khi khởi động:

### Users
- Nguyen Van A (nguyenvana@example.com)
- Tran Thi B (tranthib@example.com)
- Le Van C (levanc@example.com)

### Categories
- Electronics
- Clothing  
- Books

### Products
- iPhone 15, Samsung Galaxy S24, MacBook Pro (Electronics - User A)
- Nike Air Max, Adidas Ultraboost (Clothing - User B)
- Spring Boot Guide, Java Programming (Books - User C)

## Technologies Used
- **Spring Boot 3.1.5**
- **Spring GraphQL**
- **Spring Data JPA**
- **H2 Database** (development)
- **MySQL** (production ready)
- **JSP + Bootstrap 5**
- **jQuery + AJAX**

## Note
- Application sử dụng H2 in-memory database cho development
- Data sẽ bị reset khi restart application
- Để sử dụng MySQL, cập nhật `application.properties`