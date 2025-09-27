package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.User;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByEmail(String email);
    
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.products LEFT JOIN FETCH u.categories WHERE u.id = :id")
    Optional<User> findByIdWithProductsAndCategories(Long id);
    
    @Query("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.products LEFT JOIN FETCH u.categories")
    java.util.List<User> findAllWithProductsAndCategories();
    
    boolean existsByEmail(String email);
}