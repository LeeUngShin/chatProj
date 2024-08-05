package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatDataRepository extends JpaRepository<ChatData, Long>{
	Long countByIdAndNickname(Long id, String nickname);
}
