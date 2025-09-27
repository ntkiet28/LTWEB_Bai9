package vn.iotstar.config;

import graphql.schema.Coercing;
import graphql.schema.GraphQLScalarType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.graphql.execution.RuntimeWiringConfigurer;

import java.math.BigDecimal;

@Configuration
public class GraphQLConfig {
    
    @Bean
    public RuntimeWiringConfigurer runtimeWiringConfigurer() {
        return wiringBuilder -> wiringBuilder
            .scalar(bigDecimalScalar());
    }
    
    @Bean
    public GraphQLScalarType bigDecimalScalar() {
        return GraphQLScalarType.newScalar()
            .name("BigDecimal")
            .description("A custom scalar for BigDecimal values")
            .coercing(new Coercing<BigDecimal, String>() {
                @Override
                public String serialize(Object dataFetcherResult) {
                    if (dataFetcherResult instanceof BigDecimal) {
                        return ((BigDecimal) dataFetcherResult).toString();
                    }
                    throw new RuntimeException("Cannot serialize " + dataFetcherResult + " as BigDecimal");
                }
                
                @Override
                public BigDecimal parseValue(Object input) {
                    if (input instanceof String) {
                        return new BigDecimal((String) input);
                    } else if (input instanceof Number) {
                        return new BigDecimal(input.toString());
                    }
                    throw new RuntimeException("Cannot parse " + input + " as BigDecimal");
                }
                
                @Override
                public BigDecimal parseLiteral(Object input) {
                    if (input instanceof String) {
                        return new BigDecimal((String) input);
                    }
                    throw new RuntimeException("Cannot parse literal " + input + " as BigDecimal");
                }
            })
            .build();
    }
}