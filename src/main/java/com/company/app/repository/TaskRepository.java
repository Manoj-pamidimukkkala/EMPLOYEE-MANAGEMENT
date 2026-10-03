package com.company.app.repository;

import com.company.app.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByStatus(Task.Status status);
    List<Task> findByAssigneeId(Long assigneeId);
}
