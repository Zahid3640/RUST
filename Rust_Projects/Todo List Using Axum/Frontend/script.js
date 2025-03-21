document.addEventListener("DOMContentLoaded", () => {
    let input = document.querySelector("#todo-input");
    let addBtn = document.querySelector("#add-btn");
    let todoContainer = document.querySelector("#todo-container");

    addBtn.addEventListener("click", async () => {
        let todoBody = input.value.trim();
        if (todoBody !== "") {
            let newTodo = await postTodo(todoBody);
            if (newTodo) {
                addTodoToDOM(newTodo);
                input.value = "";
            }
        }
    });

    async function postTodo(todoBody) {
        try {
            let resp = await fetch("http://127.0.0.1:3000/todos", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ title: todoBody })
            });
            return await resp.json();
        } catch (error) {
            console.error("Error Posting Todo:", error);
        }
    }

    async function listTodos() {
        try {
            let resp = await fetch("http://127.0.0.1:3000/todos");
            let todos = await resp.json();
            todos.forEach(todo => addTodoToDOM(todo));
        } catch (error) {
            console.error("Error Fetching Todos:", error);
        }
    }

    function addTodoToDOM(todo) {
        let todoDiv = document.createElement("div");
        todoDiv.classList.add("todo");
        todoDiv.innerHTML = `
            <p contenteditable="false">${todo.title}</p>
            <button class="edit" data-id="${todo.id}">Edit</button>
            <button class="delete" data-id="${todo.id}">Delete</button>
        `;
        todoContainer.appendChild(todoDiv);

        todoDiv.querySelector(".delete").addEventListener("click", async (e) => {
            let id = e.target.dataset.id;
            await deleteTodo(id);
            todoDiv.remove();
        });

        todoDiv.querySelector(".edit").addEventListener("click", async (e) => {
            let pTag = todoDiv.querySelector("p");
            let editButton = e.target;
            if (pTag.contentEditable === "false") {
                pTag.contentEditable = "true";
                pTag.focus();
                editButton.textContent = "Save";
            } else {
                let newTitle = pTag.textContent.trim();
                let id = e.target.dataset.id;
                if (newTitle !== "") {
                    await updateTodo(id, newTitle);
                    pTag.contentEditable = "false";
                    editButton.textContent = "Edit";
                }
            }
        });
    }

    async function deleteTodo(id) {
        try {
            await fetch(`http://127.0.0.1:3000/todos/${id}`, { method: "DELETE" });
        } catch (error) {
            console.error("Error Deleting Todo:", error);
        }
    }

    async function updateTodo(id, newTitle) {
        try {
            await fetch(`http://127.0.0.1:3000/todos/${id}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ title: newTitle })
            });
        } catch (error) {
            console.error("Error Updating Todo:", error);
        }
    }

    listTodos();
});
