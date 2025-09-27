package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.User;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.ProductService;
import vn.iotstar.service.UserService;
import vn.iotstar.dto.*;

import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class GraphQLController {
    
    private static final Logger logger = LoggerFactory.getLogger(GraphQLController.class);
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private ProductService productService;
    
    // ==================== QUERIES ====================
    
    // User Queries
    @QueryMapping
    public List<User> users() {
        return userService.getAllUsers();
    }
    
    @QueryMapping
    public User user(@Argument Long id) {
        Optional<User> user = userService.getUserById(id);
        return user.orElse(null);
    }
    
    @QueryMapping
    public User userByEmail(@Argument String email) {
        Optional<User> user = userService.getUserByEmail(email);
        return user.orElse(null);
    }
    
    // Category Queries
    @QueryMapping
    public List<Category> categories() {
        return categoryService.getAllCategories();
    }
    
    @QueryMapping
    public Category category(@Argument Long id) {
        Optional<Category> category = categoryService.getCategoryById(id);
        return category.orElse(null);
    }
    
    @QueryMapping
    public Category categoryByName(@Argument String name) {
        Optional<Category> category = categoryService.getCategoryByName(name);
        return category.orElse(null);
    }
    
    // Product Queries
    @QueryMapping
    public List<Product> products() {
        return productService.getAllProducts();
    }
    
    @QueryMapping
    public Product product(@Argument Long id) {
        Optional<Product> product = productService.getProductById(id);
        return product.orElse(null);
    }
    
    @QueryMapping
    public List<Product> productsByPriceAsc() {
        return productService.getProductsByPriceAsc();
    }
    
    @QueryMapping
    public List<Product> productsByCategory(@Argument Long categoryId) {
        return productService.getProductsByCategory(categoryId);
    }
    
    @QueryMapping
    public List<Product> productsByUser(@Argument Long userId) {
        return productService.getProductsByUser(userId);
    }
    
    // ==================== MUTATIONS ====================
    
    // User Mutations
    @MutationMapping
    public User createUser(@Argument UserInput input) {
        try {
            logger.info("Creating user with input: {}", input.getEmail());
            
            if (input == null) {
                throw new RuntimeException("User input cannot be null");
            }
            
            if (input.getFullname() == null || input.getFullname().trim().isEmpty()) {
                throw new RuntimeException("Full name is required");
            }
            
            if (input.getEmail() == null || input.getEmail().trim().isEmpty()) {
                throw new RuntimeException("Email is required");
            }
            
            if (input.getPassword() == null || input.getPassword().trim().isEmpty()) {
                throw new RuntimeException("Password is required");
            }
            
            User user = new User();
            user.setFullname(input.getFullname().trim());
            user.setEmail(input.getEmail().trim());
            user.setPassword(input.getPassword().trim());
            user.setPhone(input.getPhone() != null ? input.getPhone().trim() : null);
            
            User createdUser = userService.createUser(user);
            logger.info("User created successfully with ID: {}", createdUser.getId());
            return createdUser;
        } catch (Exception e) {
            logger.error("Error creating user: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to create user: " + e.getMessage());
        }
    }
    
    @MutationMapping
    public User updateUser(@Argument UserUpdateInput input) {
        User user = new User();
        user.setId(input.getId());
        if (input.getFullname() != null) user.setFullname(input.getFullname());
        if (input.getEmail() != null) user.setEmail(input.getEmail());
        if (input.getPassword() != null) user.setPassword(input.getPassword());
        if (input.getPhone() != null) user.setPhone(input.getPhone());
        return userService.updateUser(user);
    }
    
    @MutationMapping
    public Boolean deleteUser(@Argument String id) {
        try {
            logger.info("Deleting user with ID: {}", id);
            
            if (id == null || id.trim().isEmpty()) {
                throw new RuntimeException("User ID cannot be null or empty");
            }
            
            Long userId = Long.parseLong(id.trim());
            boolean result = userService.deleteUser(userId);
            
            if (result) {
                logger.info("User deleted successfully with ID: {}", userId);
            } else {
                logger.warn("User not found or could not be deleted with ID: {}", userId);
            }
            
            return result;
        } catch (NumberFormatException e) {
            logger.error("Invalid user ID format: {}", id);
            throw new RuntimeException("Invalid user ID format: " + id);
        } catch (Exception e) {
            logger.error("Error deleting user with ID {}: {}", id, e.getMessage(), e);
            throw new RuntimeException("Failed to delete user: " + e.getMessage());
        }
    }
    
    // Category Mutations
    @MutationMapping
    public Category createCategory(@Argument CategoryInput input) {
        Category category = new Category();
        category.setName(input.getName());
        category.setImages(input.getImages());
        return categoryService.createCategory(category);
    }
    
    @MutationMapping
    public Category updateCategory(@Argument CategoryUpdateInput input) {
        Category category = new Category();
        category.setId(input.getId());
        if (input.getName() != null) category.setName(input.getName());
        if (input.getImages() != null) category.setImages(input.getImages());
        return categoryService.updateCategory(category);
    }
    
    @MutationMapping
    public Boolean deleteCategory(@Argument Long id) {
        return categoryService.deleteCategory(id);
    }
    
    // Product Mutations
    @MutationMapping
    public Product createProduct(@Argument ProductInput input) {
        // Lấy user từ database
        Optional<User> userOpt = userService.getUserById(input.getUserId());
        if (!userOpt.isPresent()) {
            throw new RuntimeException("User not found with id: " + input.getUserId());
        }
        
        Product product = new Product();
        product.setTitle(input.getTitle());
        product.setQuantity(input.getQuantity());
        product.setDesc(input.getDesc());
        product.setPrice(input.getPrice());
        product.setUser(userOpt.get());
        return productService.createProduct(product);
    }
    
    @MutationMapping
    public Product updateProduct(@Argument ProductUpdateInput input) {
        Product product = new Product();
        product.setId(input.getId());
        if (input.getTitle() != null) product.setTitle(input.getTitle());
        if (input.getQuantity() != null) product.setQuantity(input.getQuantity());
        if (input.getDesc() != null) product.setDesc(input.getDesc());
        if (input.getPrice() != null) product.setPrice(input.getPrice());
        
        if (input.getUserId() != null) {
            Optional<User> userOpt = userService.getUserById(input.getUserId());
            if (!userOpt.isPresent()) {
                throw new RuntimeException("User not found with id: " + input.getUserId());
            }
            product.setUser(userOpt.get());
        }
        
        return productService.updateProduct(product);
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument Long id) {
        return productService.deleteProduct(id);
    }
    
    // Association Mutations
    @MutationMapping
    public Boolean addUserToCategory(@Argument Long userId, @Argument Long categoryId) {
        return userService.addUserToCategory(userId, categoryId);
    }
    
    @MutationMapping
    public Boolean removeUserFromCategory(@Argument Long userId, @Argument Long categoryId) {
        return userService.removeUserFromCategory(userId, categoryId);
    }
}