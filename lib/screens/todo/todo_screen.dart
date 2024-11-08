// lib/presentation/screens/todo/todo_screen.dart
import 'package:flutter/material.dart';
import '../../../data/database/database_helper.dart';
import '../../../data/models/todo.dart';
import 'widgets/todo_item.dart';
import 'widgets/add_todo_dialog.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final todos = await _db.getAllTodos();

      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load todos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo(String title, String description) async {
    try {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      await _db.insertTodo(todo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add todo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateTodo(Todo todo) async {
    try {
      await _db.updateTodo(todo);
      await _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update todo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeTodo(String id) async {
    try {
      await _db.deleteTodo(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete todo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearAllTodos() async {
    try {
      await _db.deleteAllTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All todos cleared successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clear todos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTodos,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Todos'),
                  content: const Text('Are you sure you want to delete all todos?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete All'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _clearAllTodos();
              }
            },
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _addTodo),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTodos,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No todos yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new todo using the + button',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTodos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return TodoItem(
            key: ValueKey(_todos[index].id),
            todo: _todos[index],
            onDelete: () => _removeTodo(_todos[index].id),
            onUpdate: _updateTodo,
          );
        },
      ),
    );
  }
}