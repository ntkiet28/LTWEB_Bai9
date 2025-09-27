<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - GraphQL Demo</title>
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
                <a class="nav-link active" href="${contextPath}/categories">Categories</a>
                <a class="nav-link" href="${contextPath}/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2>Categories Management</h2>
                
                <!-- Controls -->
                <div class="card mb-4">
                    <div class="card-body">
                        <button class="btn btn-primary" onclick="showAddCategoryModal()">Add Category</button>
                        <button class="btn btn-success" onclick="loadCategories()">Refresh</button>
                    </div>
                </div>

                <!-- Categories Table -->
                <div class="card">
                    <div class="card-body">
                        <div id="loading" class="text-center" style="display: none;">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        
                        <div id="categoriesTable">
                            <!-- Categories will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addCategoryForm">
                        <div class="mb-3">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" id="categoryName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Images</label>
                            <input type="text" class="form-control" id="categoryImages" placeholder="Image URL or filename">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="addCategory()">Add Category</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Manage Users Modal -->
    <div class="modal fade" id="manageUsersModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Manage Users for Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Available Users</h6>
                            <div id="availableUsers"></div>
                        </div>
                        <div class="col-md-6">
                            <h6>Current Users</h6>
                            <div id="currentUsers"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentCategoryId = null;

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

        // Load all categories
        async function loadCategories() {
            showLoading(true);
            const query = `
                query {
                    categories {
                        id
                        name
                        images
                        users {
                            id
                            fullname
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                displayCategories(data.categories);
            }
            showLoading(false);
        }

        // Display categories in table
        function displayCategories(categories) {
            let html = `
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Images</th>
                            <th>Users Count</th>
                            <th>Users</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            categories.forEach(category => {
                const users = category.users.map(user => user.fullname).join(', ') || 'None';
                
                html += `
                    <tr>
                        <td>${category.name}</td>
                        <td>${category.images || 'N/A'}</td>
                        <td>${category.users.length}</td>
                        <td>${users}</td>
                        <td>
                            <button class="btn btn-sm btn-info" onclick="manageUsers(${category.id})">Manage Users</button>
                            <button class="btn btn-sm btn-danger" onclick="deleteCategory(${category.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });
            
            html += `
                    </tbody>
                </table>
            `;
            
            document.getElementById('categoriesTable').innerHTML = html;
        }

        // Show/hide loading spinner
        function showLoading(show) {
            document.getElementById('loading').style.display = show ? 'block' : 'none';
        }

        // Show add category modal
        function showAddCategoryModal() {
            new bootstrap.Modal(document.getElementById('addCategoryModal')).show();
        }

        // Add category
        async function addCategory() {
            const name = document.getElementById('categoryName').value;
            const images = document.getElementById('categoryImages').value || null;
            
            if (!name) {
                alert('Please enter category name');
                return;
            }
            
            const mutation = `
                mutation($input: CategoryInput!) {
                    createCategory(input: $input) {
                        id
                        name
                        images
                    }
                }
            `;
            
            const variables = {
                input: {
                    name,
                    images
                }
            };
            
            const data = await executeGraphQL(mutation, variables);
            if (data) {
                bootstrap.Modal.getInstance(document.getElementById('addCategoryModal')).hide();
                document.getElementById('addCategoryForm').reset();
                loadCategories();
            }
        }

        // Delete category
        async function deleteCategory(id) {
            if (!confirm('Are you sure you want to delete this category?')) {
                return;
            }
            
            const mutation = `
                mutation($id: ID!) {
                    deleteCategory(id: $id)
                }
            `;
            
            const data = await executeGraphQL(mutation, { id });
            if (data && data.deleteCategory) {
                loadCategories();
            }
        }

        // Manage users for category
        async function manageUsers(categoryId) {
            currentCategoryId = categoryId;
            
            // Load all users
            const usersQuery = `
                query {
                    users {
                        id
                        fullname
                        categories {
                            id
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(usersQuery);
            if (data) {
                const users = data.users;
                const currentUsers = users.filter(user => 
                    user.categories.some(cat => cat.id == categoryId)
                );
                const availableUsers = users.filter(user => 
                    !user.categories.some(cat => cat.id == categoryId)
                );
                
                displayAvailableUsers(availableUsers);
                displayCurrentUsers(currentUsers);
                
                new bootstrap.Modal(document.getElementById('manageUsersModal')).show();
            }
        }

        // Display available users
        function displayAvailableUsers(users) {
            let html = '<div class="list-group">';
            users.forEach(user => {
                html += `
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        ${user.fullname}
                        <button class="btn btn-sm btn-primary" onclick="addUserToCategory(${user.id})">Add</button>
                    </div>
                `;
            });
            html += '</div>';
            document.getElementById('availableUsers').innerHTML = html;
        }

        // Display current users
        function displayCurrentUsers(users) {
            let html = '<div class="list-group">';
            users.forEach(user => {
                html += `
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        ${user.fullname}
                        <button class="btn btn-sm btn-danger" onclick="removeUserFromCategory(${user.id})">Remove</button>
                    </div>
                `;
            });
            html += '</div>';
            document.getElementById('currentUsers').innerHTML = html;
        }

        // Add user to category
        async function addUserToCategory(userId) {
            const mutation = `
                mutation($userId: ID!, $categoryId: ID!) {
                    addUserToCategory(userId: $userId, categoryId: $categoryId)
                }
            `;
            
            const data = await executeGraphQL(mutation, { userId, categoryId: currentCategoryId });
            if (data && data.addUserToCategory) {
                manageUsers(currentCategoryId); // Refresh the modal
                loadCategories(); // Refresh the main table
            }
        }

        // Remove user from category
        async function removeUserFromCategory(userId) {
            const mutation = `
                mutation($userId: ID!, $categoryId: ID!) {
                    removeUserFromCategory(userId: $userId, categoryId: $categoryId)
                }
            `;
            
            const data = await executeGraphQL(mutation, { userId, categoryId: currentCategoryId });
            if (data && data.removeUserFromCategory) {
                manageUsers(currentCategoryId); // Refresh the modal
                loadCategories(); // Refresh the main table
            }
        }

        // Initialize page
        $(document).ready(function() {
            loadCategories();
        });
    </script>
</body>
</html>