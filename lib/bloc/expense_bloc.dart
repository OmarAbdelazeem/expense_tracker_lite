import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import '../services/currency_service.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final StorageService _storageService;
  final CurrencyService _currencyService;
  static const int _pageLimit = 10;

  ExpenseBloc({
    required StorageService storageService,
    required CurrencyService currencyService,
  })  : _storageService = storageService,
        _currencyService = currencyService,
        super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<FilterExpenses>(_onFilterExpenses);
    on<RefreshExpenses>(_onRefreshExpenses);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = _storageService.getExpensesPaginated(
        page: event.page,
        limit: event.limit,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      final totalAmount = _storageService.getTotalExpensesAmount(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      final totalCount = _storageService.getTotalExpenseCount(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      final hasMore = (event.page + 1) * event.limit < totalCount;

      emit(ExpenseLoaded(
        expenses: expenses,
        totalAmount: totalAmount,
        currentPage: event.page,
        hasMore: hasMore,
        filterStartDate: event.startDate,
        filterEndDate: event.endDate,
      ));
    } catch (e) {
      emit(ExpenseError(message: 'Failed to load expenses: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreExpenses(
    LoadMoreExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      
      try {
        emit(currentState.copyWith(isLoadingMore: true));

        final newPage = currentState.currentPage + 1;
        final newExpenses = _storageService.getExpensesPaginated(
          page: newPage,
          limit: _pageLimit,
          startDate: event.startDate,
          endDate: event.endDate,
        );

        final allExpenses = [...currentState.expenses, ...newExpenses];
        
        final totalCount = _storageService.getTotalExpenseCount(
          startDate: event.startDate,
          endDate: event.endDate,
        );

        final hasMore = (newPage + 1) * _pageLimit < totalCount;

        emit(ExpenseLoaded(
          expenses: allExpenses,
          totalAmount: currentState.totalAmount,
          currentPage: newPage,
          hasMore: hasMore,
          filterStartDate: event.startDate,
          filterEndDate: event.endDate,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(ExpenseError(message: 'Failed to load more expenses: ${e.toString()}'));
      }
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _storageService.addExpense(event.expense);
      
      // Reload expenses to show the new one
      add(const LoadExpenses());
      
    } catch (e) {
      emit(ExpenseError(message: 'Failed to add expense: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _storageService.updateExpense(event.expense);
      
      // Reload expenses to show the updated one
      add(const LoadExpenses());
      
    } catch (e) {
      emit(ExpenseError(message: 'Failed to update expense: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _storageService.deleteExpense(event.expenseId);
      
      // Reload expenses to reflect the deletion
      add(const LoadExpenses());
      
    } catch (e) {
      emit(ExpenseError(message: 'Failed to delete expense: ${e.toString()}'));
    }
  }

  Future<void> _onFilterExpenses(
    FilterExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    add(LoadExpenses(
      startDate: event.startDate,
      endDate: event.endDate,
      page: 0,
      limit: _pageLimit,
    ));
  }

  Future<void> _onRefreshExpenses(
    RefreshExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    add(LoadExpenses(
      startDate: event.startDate,
      endDate: event.endDate,
      page: 0,
      limit: _pageLimit,
    ));
  }
}