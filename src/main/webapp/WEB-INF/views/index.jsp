<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GraphQL Spring Boot Application</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${contextPath}/">GraphQL Demo</a>
            <div class="navbar-nav">
                <a class="nav-link" href="${contextPath}/products">Products</a>
                <a class="nav-link" href="${contextPath}/users">Users</a>
                <a class="nav-link" href="${contextPath}/categories">Categories</a>
                <a class="nav-link" href="${contextPath}/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1>Welcome to GraphQL Spring Boot Demo</h1>
                <p class="lead">This application demonstrates GraphQL integration with Spring Boot 3</p>
                
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Products</h5>
                                <p class="card-text">Manage products, view by price, and filter by categories.</p>
                                <a href="${contextPath}/products" class="btn btn-primary">View Products</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Users</h5>
                                <p class="card-text">Manage users and their relationships with categories.</p>
                                <a href="${contextPath}/users" class="btn btn-primary">View Users</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Categories</h5>
                                <p class="card-text">Manage product categories.</p>
                                <a href="${contextPath}/categories" class="btn btn-primary">View Categories</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="alert alert-info mt-4">
                    <h6>GraphQL Features:</h6>
                    <ul>
                        <li>View all products sorted by price (low to high)</li>
                        <li>Get products by category</li>
                        <li>CRUD operations for Users, Products, and Categories</li>
                        <li>Many-to-many relationship between Users and Categories</li>
                    </ul>
                    <p><strong>GraphQL Playground:</strong> <a href="${contextPath}/graphiql" target="_blank">Access GraphiQL</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>