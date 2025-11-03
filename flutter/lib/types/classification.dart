enum Classification {
  dairyFarm('DairyFarm'),
  intensivePoultryFarm('IntensivePoultryFarm'),
  intensivePigFarm('IntensivePigFarm'),
  intensiveSowFarm('IntensiveSowFarm');

  final String value;
  const Classification(this.value);
}