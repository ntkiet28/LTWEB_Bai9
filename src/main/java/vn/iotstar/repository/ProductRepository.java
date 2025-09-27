package vn.iotstar.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Product;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Tìm tất cả sản phẩm sắp xếp theo giá từ thấp đến cao
    @Query("SELECT p FROM Product p ORDER BY p.price ASC")
    List<Product> findAllOrderByPriceAsc();
    
    // Tìm tất cả sản phẩm của một category thông qua user
    @Query("SELECT p FROM Product p JOIN p.user u JOIN u.categories c WHERE c.id = :categoryId")
    List<Product> findByCategoryId(@Param("categoryId") Long categoryId);
    
    // Tìm sản phẩm theo user
    List<Product> findByUserId(Long userId);
    
    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.user WHERE p.id = :id")
    Optional<Product> findByIdWithUser(Long id);
}