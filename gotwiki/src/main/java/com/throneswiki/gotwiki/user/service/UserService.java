package com.throneswiki.gotwiki.user.service;

import com.throneswiki.gotwiki.user.entity.User;
import com.throneswiki.gotwiki.user.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    // REGISTER
    public void register(User user) {
        repository.save(user);
    }

    // LOGIN
    public boolean login(String username, String password) {
        Optional<User> userOpt = repository.findByUsername(username);

        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();

        // 🔴 DÜZ ŞİFRE KARŞILAŞTIRMA
        return user.getPassword().equals(password);
    }
}
