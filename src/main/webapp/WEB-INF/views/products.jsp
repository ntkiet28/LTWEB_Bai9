<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - GraphQL Demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${contextPath}/">GraphQL Demo</a>
            <div class="navbar-nav">
                <a class="nav-link active" href="${contextPath}/products">Products</a>
                <a class="nav-link" href="${contextPath}/users">Users</a>
                <a class="nav-link" href="${contextPath}/categories">Categories</a>
                <a class="nav-link" href="${contextPath}/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2>Products Management</h2>
                
                <!-- Filter Controls -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <button class="btn btn-success" onclick="loadAllProducts()">All Products</button>
                                <button class="btn btn-info" onclick="loadProductsByPrice()">Sort by Price (Low to High)</button>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" id="categoryFilter" onchange="loadProductsByCategory()">
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <button class="btn btn-primary" onclick="showAddProductModal()">Add Product</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="card">
                    <div class="card-body">
                        <div id="loading" class="text-center" style="display: none;">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        
                        <div id="productsTable">
                            <!-- Products will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addProductForm">
                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" id="productTitle" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quantity</label>
                            <input type="number" class="form-control" id="productQuantity">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" id="productDesc" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Price</label>
                            <input type="number" step="0.01" class="form-control" id="productPrice" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">User</label>
                            <select class="form-select" id="productUser" required>
                                <option value="">Select User</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="addProduct()">Add Product</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let categories = [];
        let users = [];

        // GraphQL Helper Function
        async function executeGraphQL(query, variables = {}) {
            const response = await fetch('${contextPath}/graphql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    query: query,
                    variables: variables
                })
            });
            
            const result = await response.json();
            if (result.errors) {
                console.error('GraphQL Errors:', result.errors);
                alert('Error: ' + result.errors[0].message);
                return null;
            }
            return result.data;
        }

        // Load all products
        async function loadAllProducts() {
            showLoading(true);
            const query = `
                query {
                    products {
                        id
                        title
                        quantity
                        desc
                        price
                        user {
                            fullname
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                displayProducts(data.products);
            }
            showLoading(false);
        }

        // Load products sorted by price
        async function loadProductsByPrice() {
            showLoading(true);
            const query = `
                query {
                    productsByPriceAsc {
                        id
                        title
                        quantity
                        desc
                        price
                        user {
                            fullname
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                displayProducts(data.productsByPriceAsc);
            }
            showLoading(false);
        }

        // Load products by category
        async function loadProductsByCategory() {
            const categoryId = document.getElementById('categoryFilter').value;
            if (!categoryId) return;
            
            showLoading(true);
            const query = `
                query($categoryId: ID!) {
                    productsByCategory(categoryId: $categoryId) {
                        id
                        title
                        quantity
                        desc
                        price
                        user {
                            fullname
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(query, { categoryId });
            if (data) {
                displayProducts(data.productsByCategory);
            }
            showLoading(false);
        }

        // Load categories for filter
        async function loadCategories() {
            const query = `
                query {
                    categories {
                        id
                        name
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                categories = data.categories;
                const select = document.getElementById('categoryFilter');
                select.innerHTML = '<option value="">Select Category</option>';
                categories.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.id;
                    option.textContent = category.name;
                    select.appendChild(option);
                });
            }
        }

        // Load users for add product form
        async function loadUsers() {
            const query = `
                query {
                    users {
                        id
                        fullname
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                users = data.users;
                const select = document.getElementById('productUser');
                select.innerHTML = '<option value="">Select User</option>';
                users.forEach(user => {
                    const option = document.createElement('option');
                    option.value = user.id;
                    option.textContent = user.fullname;
                    select.appendChild(option);
                });
            }
        }

        // Display products in table
        function displayProducts(products) {
            let html = `
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Quantity</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>User</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            products.forEach(product => {
                html += `
                    <tr>
                        <td>${product.title}</td>
                        <td>${product.quantity || 'N/A'}</td>
                        <td>${product.desc || 'N/A'}</td>
                        <td>$${product.price}</td>
                        <td>${product.user.fullname}</td>
                        <td>
                            <button class="btn btn-sm btn-danger" onclick="deleteProduct(${product.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });
            
            html += `
                    </tbody>
                </table>
            `;
            
            document.getElementById('productsTable').innerHTML = html;
        }

        // Show/hide loading spinner
        function showLoading(show) {
            document.getElementById('loading').style.display = show ? 'block' : 'none';
        }

        // Show add product modal
        function showAddProductModal() {
            new bootstrap.Modal(document.getElementById('addProductModal')).show();
        }

        // Add product
        async function addProduct() {
            const title = document.getElementById('productTitle').value;
            const quantity = parseInt(document.getElementById('productQuantity').value) || null;
            const desc = document.getElementById('productDesc').value || null;
            const price = parseFloat(document.getElementById('productPrice').value);
            const userId = document.getElementById('productUser').value;
            
            if (!title || !price || !userId) {
                alert('Please fill in required fields');
                return;
            }
            
            const mutation = `
                mutation($input: ProductInput!) {
                    createProduct(input: $input) {
                        id
                        title
                        price
                    }
                }
            `;
            
            const variables = {
                input: {
                    title,
                    quantity,
                    desc,
                    price,
                    userId
                }
            };
            
            const data = await executeGraphQL(mutation, variables);
            if (data) {
                bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
                document.getElementById('addProductForm').reset();
                loadAllProducts();
            }
        }

        // Delete product
        async function deleteProduct(id) {
            if (!confirm('Are you sure you want to delete this product?')) {
                return;
            }
            
            const mutation = `
                mutation($id: ID!) {
                    deleteProduct(id: $id)
                }
            `;
            
            const data = await executeGraphQL(mutation, { id });
            if (data && data.deleteProduct) {
                loadAllProducts();
            }
        }

        // Initialize page
        $(document).ready(function() {
            loadCategories();
            loadUsers();
            loadAllProducts();
        });
    </script>
</body>
</html>