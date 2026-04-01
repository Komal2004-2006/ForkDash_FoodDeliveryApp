package com.tap.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items = new ArrayList<>();

    // Add item — if already in cart, increase quantity
    public void addItem(CartItem newItem) {
        for (CartItem item : items) {
            if (item.getItemId() == newItem.getItemId()) {
                item.setQuantity(item.getQuantity() + 1);
                return;
            }
        }
        newItem.setQuantity(1);
        items.add(newItem);
    }

    // Remove item completely by itemId
    public void removeItem(int itemId) {
        items.removeIf(item -> item.getItemId() == itemId);
    }

    // Increase quantity by 1
    public void increaseQty(int itemId) {
        for (CartItem item : items) {
            if (item.getItemId() == itemId) {
                item.setQuantity(item.getQuantity() + 1);
                return;
            }
        }
    }

    // Decrease quantity — remove if it hits 0
    public void decreaseQty(int itemId) {
        for (CartItem item : items) {
            if (item.getItemId() == itemId) {
                if (item.getQuantity() <= 1) {
                    removeItem(itemId);
                } else {
                    item.setQuantity(item.getQuantity() - 1);
                }
                return;
            }
        }
    }

    // Clear entire cart
    public void clear() {
        items.clear();
    }

    // Grand total
    public double getTotal() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return total;
    }

    // Total item count
    public int getItemCount() {
        int count = 0;
        for (CartItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }

    public List<CartItem> getItems() { return items; }
    public boolean isEmpty()         { return items.isEmpty(); }
}