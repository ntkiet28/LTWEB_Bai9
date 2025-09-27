package vn.iotstar;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class BTGraphQLApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(BTGraphQLApplication.class, args);
    }

}