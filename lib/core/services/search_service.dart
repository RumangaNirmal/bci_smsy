class SearchService {
  const SearchService._();

  static bool matchesQuery(String value, String query) {
    final String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }
    return value.toLowerCase().contains(normalizedQuery);
  }
}
