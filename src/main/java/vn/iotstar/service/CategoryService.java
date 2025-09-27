package vn.iotstar.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Category;
import vn.iotstar.repository.CategoryRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoryService {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    public Optional<Category> getCategoryById(Long id) {
        return categoryRepository.findByIdWithUsers(id);
    }
    
    public Optional<Category> getCategoryByName(String name) {
        return categoryRepository.findByName(name);
    }
    
    public Category createCategory(Category category) {
        if (categoryRepository.existsByName(category.getName())) {
            throw new RuntimeException("Category name already exists: " + category.getName());
        }
        return categoryRepository.save(category);
    }
    
    public Category updateCategory(Category category) {
        if (!categoryRepository.existsById(category.getId())) {
            throw new RuntimeException("Category not found with id: " + category.getId());
        }
        
        Optional<Category> existingCategory = categoryRepository.findByName(category.getName());
        if (existingCategory.isPresent() && !existingCategory.get().getId().equals(category.getId())) {
            throw new RuntimeException("Category name already exists: " + category.getName());
        }
        
        return categoryRepository.save(category);
    }
    
    public boolean deleteCategory(Long id) {
        if (!categoryRepository.existsById(id)) {
            return false;
        }
        categoryRepository.deleteById(id);
        return true;
    }
}