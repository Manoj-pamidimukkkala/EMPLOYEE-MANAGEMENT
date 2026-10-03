from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector
import pandas as pd
from typing import Dict, List, Any

app = FastAPI(
    title="Task Analytics Microservice",
    description="Python microservice dedicated to data heavy processing, predictive velocity, and metrics calculation.",
    version="1.0.0"
)

# Enable CORS for Frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "yourpassword",
    "database": "enterprise_task_db"
}

def get_db_connection():
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database Connection Error: {str(e)}")

@app.get("/api/v1/analytics/summary")
def get_task_analytics() -> Dict[str, Any]:
    """Retrieves status aggregations and velocity metrics via Pandas processing."""
    conn = get_db_connection()
    try:
        query = "SELECT id, priority, status, assignee_id, created_at FROM tasks"
        df = pd.read_sql(query, conn)
        
        if df.empty:
            return {"total_tasks": 0, "status_distribution": {}, "priority_distribution": {}}

        status_dist = df['status'].value_counts().to_dict()
        priority_dist = df['priority'].value_counts().to_dict()
        
        return {
            "total_tasks": len(df),
            "status_distribution": status_dist,
            "priority_distribution": priority_dist,
            "completion_rate_percentage": round((status_dist.get('DONE', 0) / len(df)) * 100, 2)
        }
    finally:
        conn.close()

@app.get("/api/v1/analytics/workload")
def get_workload_distribution() -> List[Dict[str, Any]]:
    """Calculates assigned workload distribution across team members."""
    conn = get_db_connection()
    try:
        query = """
            SELECT u.name, u.role, COUNT(t.id) as task_count,
                   SUM(CASE WHEN t.status = 'DONE' THEN 1 ELSE 0 END) as completed_tasks
            FROM users u
            LEFT JOIN tasks t ON u.id = t.assignee_id
            GROUP BY u.id, u.name, u.role
        """
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    finally:
        conn.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
