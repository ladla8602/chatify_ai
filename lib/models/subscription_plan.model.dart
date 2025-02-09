class SubscriptionPlan {
  String? id;
  String? name;
  String? description;
  List<MarketingFeatures>? marketingFeatures;
  Metadata? metadata;
  Price? price;

  SubscriptionPlan({this.id, this.name, this.description, this.marketingFeatures = const [], this.metadata, this.price});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    if (json['marketing_features'] != null) {
      marketingFeatures = <MarketingFeatures>[];
      json['marketing_features'].forEach((v) {
        marketingFeatures!.add(MarketingFeatures.fromJson(v));
      });
    }
    // metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    if (marketingFeatures != null) {
      data['marketing_features'] = marketingFeatures!.map((v) => v.toJson()).toList();
    }
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    return data;
  }
}

class MarketingFeatures {
  String? name;

  MarketingFeatures({this.name});

  MarketingFeatures.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    return data;
  }
}

class Metadata {
  String? subscriptionPlan;

  Metadata({this.subscriptionPlan});

  Metadata.fromJson(Map<String, dynamic> json) {
    subscriptionPlan = json['subscription_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subscription_plan'] = subscriptionPlan;
    return data;
  }
}

class Price {
  String? id;
  String? currency;
  int? unitAmount;
  Recurring? recurring;

  Price({this.id, this.currency, this.unitAmount, this.recurring});

  Price.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    unitAmount = json['unit_amount'];
    recurring = json['recurring'] != null ? Recurring.fromJson(json['recurring']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['currency'] = currency;
    data['unit_amount'] = unitAmount;
    if (recurring != null) {
      data['recurring'] = recurring!.toJson();
    }
    return data;
  }
}

class Recurring {
  String? aggregateUsage;
  String? interval;
  int? intervalCount;
  String? meter;
  String? trialPeriodDays;
  String? usageType;

  Recurring({this.aggregateUsage, this.interval, this.intervalCount, this.meter, this.trialPeriodDays, this.usageType});

  Recurring.fromJson(Map<String, dynamic> json) {
    aggregateUsage = json['aggregate_usage'];
    interval = json['interval'];
    intervalCount = json['interval_count'];
    meter = json['meter'];
    trialPeriodDays = json['trial_period_days'];
    usageType = json['usage_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['aggregate_usage'] = aggregateUsage;
    data['interval'] = interval;
    data['interval_count'] = intervalCount;
    data['meter'] = meter;
    data['trial_period_days'] = trialPeriodDays;
    data['usage_type'] = usageType;
    return data;
  }
}
