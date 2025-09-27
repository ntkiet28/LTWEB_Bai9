<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE        // Delete user
        async function deleteUser(id) {
            try {
                console.log('Deleting user with ID:', id);
                
                if (!id) {
                    alert('Invalid user ID');
                    return;
                }
                
                if (!confirm('Are you sure you want to delete this user?')) {
                    return;
                }
                
                const mutation = `
                    mutation($id: ID!) {
                        deleteUser(id: $id)
                    }
                `;
                
                console.log('Calling delete mutation...');
                const data = await executeGraphQL(mutation, { id: id.toString() });
                
                if (data && data.deleteUser) {
                    console.log('User deleted successfully');
                    alert('User deleted successfully!');
                    await loadUsers();
                } else {
                    console.error('Failed to delete user - no confirmation returned');
                    alert('Failed to delete user. Please try again.');
                }
            } catch (error) {
                console.error('Error in deleteUser function:', error);
                alert('Error deleting user: ' + error.message);
            }
        }g="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - GraphQL Demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${contextPath}/">GraphQL Demo</a>
            <div class="navbar-nav">
                <a class="nav-link" href="${contextPath}/products">Products</a>
                <a class="nav-link active" href="${contextPath}/users">Users</a>
                <a class="nav-link" href="${contextPath}/categories">Categories</a>
                <a class="nav-link" href="${contextPath}/graphiql" target="_blank">GraphiQL</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2>Users Management</h2>
                
                <!-- Controls -->
                <div class="card mb-4">
                    <div class="card-body">
                        <button class="btn btn-primary" onclick="showAddUserModal()">Add User</button>
                        <button class="btn btn-success" onclick="loadUsers()">Refresh</button>
                        <button class="btn btn-info" onclick="testDirectCall()">Test API</button>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-body">
                        <div id="loading" class="text-center" style="display: none;">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        
                        <div id="usersTable">
                            <!-- Users will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addUserForm">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="userFullname" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="userEmail" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" id="userPassword" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" class="form-control" id="userPhone">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="addUser()">Add User</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // GraphQL Helper Function
        async function executeGraphQL(query, variables = {}) {
            try {
                console.log('Executing GraphQL query:', query);
                console.log('Variables:', variables);
                
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
                
                console.log('Response status:', response.status);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const result = await response.json();
                console.log('GraphQL result:', result);
                
                if (result.errors) {
                    console.error('GraphQL Errors:', result.errors);
                    alert('Error: ' + result.errors[0].message);
                    return null;
                }
                return result.data;
            } catch (error) {
                console.error('Network error:', error);
                alert('Network error: ' + error.message);
                return null;
            }
        }

        // Load all users
        async function loadUsers() {
            showLoading(true);
            const query = `
                query {
                    users {
                        id
                        fullname
                        email
                        phone
                        categories {
                            name
                        }
                        products {
                            title
                        }
                    }
                }
            `;
            
            const data = await executeGraphQL(query);
            if (data) {
                displayUsers(data.users);
            }
            showLoading(false);
        }

        // Display users in table
        function displayUsers(users) {
            console.log('Displaying users:', users);
            
            if (!users || users.length === 0) {
                document.getElementById('usersTable').innerHTML = `
                    <div class="alert alert-info">
                        <h5>No users found</h5>
                        <p>Click "Add User" to create your first user.</p>
                    </div>
                `;
                return;
            }
            
            let html = `
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Categories</th>
                            <th>Products Count</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            `;
            
            users.forEach(user => {
                console.log('Processing user:', user);
                
                // Safety checks and data validation
                const fullname = user.fullname || user.fullName || 'N/A';
                const email = user.email || 'N/A';
                const phone = user.phone || 'N/A';
                const categories = (user.categories && Array.isArray(user.categories)) 
                    ? user.categories.map(cat => cat.name || cat).join(', ') || 'None'
                    : 'None';
                const productsCount = (user.products && Array.isArray(user.products)) 
                    ? user.products.length 
                    : 0;
                const userId = user.id;
                
                console.log('User data processed:', { fullname, email, phone, categories, productsCount, userId });
                
                html += `
                    <tr>
                        <td>${fullname}</td>
                        <td>${email}</td>
                        <td>${phone}</td>
                        <td>${categories}</td>
                        <td>${productsCount}</td>
                        <td>
                            <button class="btn btn-sm btn-danger" onclick="deleteUser('${userId}')">Delete</button>
                        </td>
                    </tr>
                `;
            });
            
            html += `
                    </tbody>
                </table>
            `;
            
            document.getElementById('usersTable').innerHTML = html;
        }

        // Show/hide loading spinner
        function showLoading(show) {
            document.getElementById('loading').style.display = show ? 'block' : 'none';
        }

        // Show add user modal
        function showAddUserModal() {
            new bootstrap.Modal(document.getElementById('addUserModal')).show();
        }

        // Add user
        async function addUser() {
            try {
                console.log('Adding user...');
                const fullname = document.getElementById('userFullname').value.trim();
                const email = document.getElementById('userEmail').value.trim();
                const password = document.getElementById('userPassword').value.trim();
                const phone = document.getElementById('userPhone').value.trim() || null;
                
                console.log('Form data:', { fullname, email, password, phone });
                
                if (!fullname || !email || !password) {
                    alert('Please fill in required fields (Full name, Email, Password)');
                    return;
                }
                
                // Email validation
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Please enter a valid email address');
                    return;
                }
                
                const mutation = `
                    mutation($input: UserInput!) {
                        createUser(input: $input) {
                            id
                            fullname
                            email
                            phone
                        }
                    }
                `;
                
                const variables = {
                    input: {
                        fullname: fullname,
                        email: email,
                        password: password,
                        phone: phone
                    }
                };
                
                console.log('Calling GraphQL mutation...');
                const data = await executeGraphQL(mutation, variables);
                
                if (data && data.createUser) {
                    console.log('User created successfully:', data.createUser);
                    alert('User created successfully!');
                    bootstrap.Modal.getInstance(document.getElementById('addUserModal')).hide();
                    document.getElementById('addUserForm').reset();
                    await loadUsers();
                } else {
                    console.error('Failed to create user - no data returned');
                    alert('Failed to create user. Please try again.');
                }
            } catch (error) {
                console.error('Error in addUser function:', error);
                alert('Error creating user: ' + error.message);
            }
        }

        // Delete user
        async function deleteUser(id) {
            if (!confirm('Are you sure you want to delete this user?')) {
                return;
            }
            
            const mutation = `
                mutation($id: ID!) {
                    deleteUser(id: $id)
                }
            `;
            
            const data = await executeGraphQL(mutation, { id });
            if (data && data.deleteUser) {
                loadUsers();
            }
        }

        // Test direct API call
        async function testDirectCall() {
            try {
                console.log('Testing direct API call...');
                
                // Test REST endpoint
                const response = await fetch('${contextPath}/test/users');
                const users = await response.json();
                console.log('Direct API response:', users);
                
                // Test GraphQL
                const query = `
                    query {
                        users {
                            id
                            fullname
                            email
                        }
                    }
                `;
                const graphqlData = await executeGraphQL(query);
                console.log('GraphQL response:', graphqlData);
                
                alert('Check console for API test results');
            } catch (error) {
                console.error('Test API error:', error);
                alert('Test API error: ' + error.message);
            }
        }

        // Initialize page
        $(document).ready(function() {
            loadUsers();
        });
    </script>
</body>
</html>