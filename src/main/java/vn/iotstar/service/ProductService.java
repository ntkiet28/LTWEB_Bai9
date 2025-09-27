package vn.iotstar.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.Product;
import vn.iotstar.repository.ProductRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    public Optional<Product> getProductById(Long id) {
        return productRepository.findByIdWithUser(id);
    }
    
    public List<Product> getProductsByPriceAsc() {
        return productRepository.findAllOrderByPriceAsc();
    }
    
    public List<Product> getProductsByCategory(Long categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
    
    public List<Product> getProductsByUser(Long userId) {
        return productRepository.findByUserId(userId);
    }
    
    public Product createProduct(Product product) {
        return productRepository.save(product);
    }
    
    public Product updateProduct(Product product) {
        if (!productRepository.existsById(product.getId())) {
            throw new RuntimeException("Product not found with id: " + product.getId());
        }
        return productRepository.save(product);
    }
    
    public boolean deleteProduct(Long id) {
        if (!productRepository.existsById(id)) {
            return false;
        }
        productRepository.deleteById(id);
        return true;
    }
}