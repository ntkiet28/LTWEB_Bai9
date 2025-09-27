package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

@RestController
public class TestController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/test/users")
    public List<User> testUsers() {
        return userService.getAllUsers();
    }
    
    @GetMapping("/test/create-sample-user")
    public User createSampleUser() {
        User user = new User();
        user.setFullname("Test User");
        user.setEmail("test" + System.currentTimeMillis() + "@example.com");
        user.setPassword("password123");
        user.setPhone("0123456789");
        return userService.createUser(user);
    }
    
    @GetMapping("/test/status")
    public Map<String, Object> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("message", "BTGraphQL Application is running!");
        status.put("timestamp", System.currentTimeMillis());
        status.put("userCount", userService.getAllUsers().size());
        status.put("contextPath", "/BTGraphQL");
        return status;
    }
}