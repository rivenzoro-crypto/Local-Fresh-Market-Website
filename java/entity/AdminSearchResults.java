package entity;

import java.util.List;

public class AdminSearchResults {
    private List<Product> products;
    private List<Order> orders;
    private List<User> customers;

    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
    public List<Order> getOrders() { return orders; }
    public void setOrders(List<Order> orders) { this.orders = orders; }
    public List<User> getCustomers() { return customers; }
    public void setCustomers(List<User> customers) { this.customers = customers; }
}
