package vn.iotstar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {
    
    @GetMapping("/")
    public String index() {
        return "index";
    }
    
    @GetMapping("/products")
    public String products() {
        return "products";
    }
    
    @GetMapping("/users")
    public String users() {
        return "users";
    }
    
    @GetMapping("/categories")
    public String categories() {
        return "categories";
    }
    
    // HTML-based routes (fallback solution)
    @GetMapping("/users-html")
    public String usersHtml() {
        return "redirect:/users.html";
    }
    
    @GetMapping("/categories-html")
    public String categoriesHtml() {
        return "redirect:/categories.html";
    }
    
    @GetMapping("/products-html")
    public String productsHtml() {
        return "redirect:/products.html";
    }
}