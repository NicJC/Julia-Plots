using DataFrames ,UrlDownload, CSV, Gadfly;

link = "https://covid.ourworldindata.org/data/owid-covid-data.csv"
data = urldownload(link) |> DataFrame

df = data[!,[:date,:location,:total_cases,:new_cases,:total_deaths,:new_deaths,:median_age,:total_vaccinations,:people_fully_vaccinated,:new_vaccinations,:total_boosters,:population,:population_density,:stringency_index]]

data = filter(
x -> any(occursin.(["New Zealand","South Africa","India","Netherlands","United States","United Kingdom"], x.location)),
df
)

CSV.write("data.csv", data)

Gadfly.push_theme(:dark)
Gadfly.set_default_plot_size(24cm, 18cm)
ticks = [0,20000,50000,100000,150000,200000,250000,300000,350000,400000,450000,500000,550000,600000]
pl = Gadfly.plot(data, x = "new_cases", y = :date,color = "location",Geom.point, Guide.xticks(ticks=ticks),
Guide.Title("Covid by Date and new cases"),Scale.color_discrete_manual("green","purple","blue","red","black","orange"))

img = SVG("pointplot.svg", 26cm, 18cm)
draw(img, pl)

Gadfly.push_theme(:dark)
Gadfly.set_default_plot_size(28cm, 22cm)
ticks = [0,500000, 1000000 , 1500000 , 2000000 , 2500000,5000000,10000000,15000000,20000000]
pl2 = Gadfly.plot(data, x = :date
    ,y = :new_vaccinations
    ,color = "location"
    , Geom.point
    , Guide.XLabel("Date")
    , Guide.YLabel("new_vaccinations")
    ,Guide.Title("covid by Date and vaccinations by location")
    ,Scale.color_discrete_manual("purple","black","steelblue","red","green","salmon"), Guide.yticks(ticks=ticks))

    img = SVG("pointplot2.svg", 26cm, 20cm)
    draw(img, pl2)
