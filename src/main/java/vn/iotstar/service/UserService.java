package vn.iotstar.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Category;
import vn.iotstar.repository.UserRepository;
import vn.iotstar.repository.CategoryRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    public List<User> getAllUsers() {
        return userRepository.findAllWithProductsAndCategories();
    }
    
    public Optional<User> getUserById(Long id) {
        return userRepository.findByIdWithProductsAndCategories(id);
    }
    
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public User createUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already exists: " + user.getEmail());
        }
        return userRepository.save(user);
    }
    
    public User updateUser(User user) {
        if (!userRepository.existsById(user.getId())) {
            throw new RuntimeException("User not found with id: " + user.getId());
        }
        
        Optional<User> existingUser = userRepository.findByEmail(user.getEmail());
        if (existingUser.isPresent() && !existingUser.get().getId().equals(user.getId())) {
            throw new RuntimeException("Email already exists: " + user.getEmail());
        }
        
        return userRepository.save(user);
    }
    
    public boolean deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            return false;
        }
        userRepository.deleteById(id);
        return true;
    }
    
    public boolean addUserToCategory(Long userId, Long categoryId) {
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Category> categoryOpt = categoryRepository.findById(categoryId);
        
        if (userOpt.isPresent() && categoryOpt.isPresent()) {
            User user = userOpt.get();
            Category category = categoryOpt.get();
            
            user.getCategories().add(category);
            category.getUsers().add(user);
            
            userRepository.save(user);
            return true;
        }
        return false;
    }
    
    public boolean removeUserFromCategory(Long userId, Long categoryId) {
        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Category> categoryOpt = categoryRepository.findById(categoryId);
        
        if (userOpt.isPresent() && categoryOpt.isPresent()) {
            User user = userOpt.get();
            Category category = categoryOpt.get();
            
            user.getCategories().remove(category);
            category.getUsers().remove(user);
            
            userRepository.save(user);
            return true;
        }
        return false;
    }
}