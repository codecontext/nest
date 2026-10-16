from fastapi.testclient import TestClient

from backend.app import main

client = TestClient(main.app)


def test_health_endpoint() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_hotels_endpoint_returns_repository_data(monkeypatch) -> None:
    monkeypatch.setattr(main, "list_hotels", lambda: [{"id": 1, "name": "Blue Harbor", "city": "Lisbon", "country": "Portugal"}])

    response = client.get("/hotels")

    assert response.status_code == 200
    assert response.json() == [{"id": 1, "name": "Blue Harbor", "city": "Lisbon", "country": "Portugal"}]
