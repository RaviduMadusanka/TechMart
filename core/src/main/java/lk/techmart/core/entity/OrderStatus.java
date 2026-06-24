package lk.techmart.core.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "order_statuses")
public class OrderStatus {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_id")
    private Long statusId;

    @Column(name = "status_name", nullable = false, unique = true)
    private String statusName;

    public Long getStatusId() {
        return statusId;
    }

    public void setStatusId(Long statusId) {
        this.statusId = statusId;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }
}
