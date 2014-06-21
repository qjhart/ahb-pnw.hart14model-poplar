\COPY (select pid,(soil).* from m3pgjs.pixel) to soil.csv with csv header


