import React from 'react';

import Table from '../components/Table';

const data = [
  {
    code: 'code1',
    name1: '名称１－１',
    name2: '名称１－２',
    name3: '名称１－３',
  },
  {
    code: 'code2',
    name1: '名称２－１',
    name2: '名称２－２',
    name3: '名称２－３',
  },
  {
    code: 'code3',
    name1: '名称３－１',
    name2: '名称３－２',
    name3: '名称３－３',
  },
  {
    code: 'code4',
    name1: '名称４－１',
    name2: '名称４－２',
    name3: '名称４－３',
  },
  {
    code: 'code5',
    name1: '名称５－１',
    name2: '名称５－２',
    name3: '名称５－３',
  },
];

const TableExample = () => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>名称１</th>
        <th>名称２</th>
        <th>名称３</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={rec.code}>
          <td>{rec.code}</td>
          <td>{rec.name1}</td>
          <td>{rec.name2}</td>
          <td>{rec.name3}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

export default TableExample;
