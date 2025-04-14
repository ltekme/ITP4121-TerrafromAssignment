# Simple Application

If inventory item name starts with `BurnerMaterial` and status is `In-Inventory` each item meeting the condition will starts calculations with numpy to stress the CPU.

```
while True:
    m1 = np.random.randn(512, 512)
    m2 = np.random.randn(512, 512)
    np.linalg.norm(np.dot(m1, m2))
```