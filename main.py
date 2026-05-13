import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine


db_url = 'postgresql+psycopg2://postgres:1234@localhost:5432/shop_analytics'

engine = create_engine(db_url)


query = """
SELECT sale_date, total_amount
FROM sales
ORDER BY sale_date ASC;
"""



df = pd.read_sql(query, engine)

df['sale_date'] = pd.to_datetime(df['sale_date'])

df.set_index(keys='sale_date', inplace=True)


daily_sales = df['total_amount'].resample('D').sum().fillna(0)

print("--- 1. Дневная выручка (последние 5 дней) ---")
print(daily_sales.tail(5))
print("\n")


cumulative_sales = daily_sales.cumsum()

print("--- 2. Накопительная выручка (последние 5 дней) ---")
print(cumulative_sales.tail(5))
print("\n")


rolling_avg_7d = daily_sales.rolling(window=7).mean().fillna(0)

print("--- 3. Скользящее среднее за 7 дней (последние 5 дней) ---")
print(rolling_avg_7d.tail(5))
print("\n")

analytics_df = pd.DataFrame({
    'Дневная выручка': daily_sales,
    'Накопительный итог': cumulative_sales,
    'Тренд (7 дней)': rolling_avg_7d
})

analytics_df = analytics_df.round(2)

print("--- ИТОГОВАЯ ТАБЛИЦА ДИНАМИКИ (фрагмент) ---")
print(analytics_df.tail(10))


plt.rcParams['font.family'] = 'DejaVu Sans'

plt.close('all')
fig, axes = plt.subplots(2, 1, figsize=(14, 10))

axes[0].bar(
    daily_sales.index,
    daily_sales.values,
    label='Дневная выручка',
    color='skyblue'
)
axes[0].plot(
    rolling_avg_7d.index,
    rolling_avg_7d.values,
    linewidth=3,
    color='orange',
    label='Скользящее среднее (7 дней)'
)
axes[0].set_title('Дневная выручка и тренд продаж')
axes[0].set_ylabel('Выручка')
axes[0].legend()
axes[0].grid(True, linestyle='--', alpha=0.7)


axes[1].plot(
    cumulative_sales.index,
    cumulative_sales.values,
    linewidth=2,
    color='green',
    label='Накопительный итог'
)

axes[1].fill_between(
    cumulative_sales.index,
    cumulative_sales.values,
    color='green',
    alpha=0.2
)
axes[1].set_title('Накопительная выручка (динамика роста)')
axes[1].set_xlabel('Дата')
axes[1].set_ylabel('Суммарная сумма')
axes[1].legend()
axes[1].grid(True, linestyle='--', alpha=0.7)


plt.tight_layout()

 
plt.show()

# При необходимости сохранить Excel
# analytics_df.to_excel('sales_dynamics.xlsx')