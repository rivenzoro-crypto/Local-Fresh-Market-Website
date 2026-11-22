package entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WholesaleApplication {
    private Long id;
    private Long userId;
    private String applicantName;
    private String applicantEmail;
    private String businessName;
    private String businessType;
    private String businessAddress;
    private String businessPhone;
    private String registrationNumber;
    private String status;
    private String rejectionReason;
    private LocalDateTime appliedAt;
    private LocalDateTime reviewedAt;
    private Long reviewedBy;
    private String reviewerName;
}
