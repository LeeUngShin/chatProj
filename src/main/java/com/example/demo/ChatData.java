package com.example.demo;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.springframework.data.annotation.CreatedDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
@Builder
@Entity
@Table(name="chatTbl")
@NoArgsConstructor
@AllArgsConstructor
public class ChatData {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) //MySQL의 AUTO_INCREMENT를 사용
	private Long id;
	
	@Column(length=50, nullable=false)
	private String nickname;
	
	@Column(length=50, nullable=false)	
	private String message; 

//	@Column(length=50, nullable=false)
//    @CreationTimestamp
//	private LocalDateTime createDate;
}