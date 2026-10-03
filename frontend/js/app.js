const JAVA_API_BASE = 'http://localhost:8080/api/v1/tasks';
const PYTHON_API_BASE = 'http://localhost:8000/api/v1/analytics';

let tasks = [];

// Initialize Lucide Icons
document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();
    loadTasks();
});

// View Navigation Switcher
function switchTab(tabName) {
    document.querySelectorAll('.nav-item').forEach(btn => btn.classList.remove('active'));
    document.querySelectorAll('.view-panel').forEach(panel => panel.classList.remove('active'));
    
    event.currentTarget.classList.add('active');
    document.getElementById(`${tabName}-view`).classList.add('active');

    if(tabName === 'analytics') {
        fetchAnalytics();
    }
}

// Fetch Tasks from Java Spring Boot Backend
async function loadTasks() {
    try {
        const response = await fetch(JAVA_API_BASE);
        tasks = await response.json();
        renderKanban();
        renderTable();
    } catch (err) {
        console.error('Failed to communicate with Java Backend:', err);
    }
}

// Render Kanban Column Lists
function renderKanban() {
    const statuses = ['TODO', 'IN_PROGRESS', 'IN_REVIEW', 'DONE'];
    
    statuses.forEach(status => {
        const listEl = document.getElementById(`list-${status.toLowerCase().replace('_', '')}`);
        const countEl = document.getElementById(`count-${status.toLowerCase().replace('_', '')}`);
        
        const filtered = tasks.filter(t => t.status === status);
        countEl.textContent = filtered.length;

        listEl.innerHTML = filtered.map(task => `
            <div class="task-card">
                <h4>${escapeHtml(task.title)}</h4>
                <div style="margin-top: 8px; font-size: 0.75rem; color: var(--text-muted);">
                    Priority: <strong>${task.priority}</strong>
                </div>
            </div>
        `).join('');
    });
}

// Render Table List
function renderTable() {
    const tbody = document.getElementById('task-table-body');
    tbody.innerHTML = tasks.map(t => `
        <tr>
            <td>#${t.id}</td>
            <td>${escapeHtml(t.title)}</td>
            <td>${t.priority}</td>
            <td>${t.status}</td>
            <td>${t.assignee ? t.assignee.name : 'Unassigned'}</td>
            <td>
                <button class="btn btn-secondary" onclick="deleteTask(${t.id})">Delete</button>
            </td>
        </tr>
    `).join('');
}

// Fetch Analytics from Python Microservice
async function fetchAnalytics() {
    try {
        const response = await fetch(`${PYTHON_API_BASE}/summary`);
        const data = await response.json();
        document.getElementById('analytics-json').textContent = JSON.stringify(data, null, 2);
    } catch (err) {
        document.getElementById('analytics-json').textContent = 'Python Microservice Offline (Port 8000)';
    }
}

// Task Submit Helper
async function handleTaskSubmit(e) {
    e.preventDefault();
    const newTask = {
        title: document.getElementById('taskTitle').value,
        priority: document.getElementById('taskPriority').value,
        status: 'TODO'
    };

    await fetch(JAVA_API_BASE, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newTask)
    });

    closeCreateModal();
    loadTasks();
}

// Modal Toggle Helpers
function openCreateModal() { document.getElementById('taskModal').style.display = 'flex'; }
function closeCreateModal() { document.getElementById('taskModal').style.display = 'none'; }

function escapeHtml(str) {
    return str.replace(/[&<>"']/g, m => ({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[m]));
}
