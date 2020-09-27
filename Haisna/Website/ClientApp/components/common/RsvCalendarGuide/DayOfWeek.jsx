/**
 * @file カレンダー検索ガイド用曜日行
 */
import React from 'react';

import Cell from './Cell';

const sunday = {
  color: '#f00',
};
const saturday = {
  color: '#06f',
};

const DayOfWeek = () => (
  <tr>
    <Cell value="日" style={sunday} />
    <Cell value="月" />
    <Cell value="火" />
    <Cell value="水" />
    <Cell value="木" />
    <Cell value="金" />
    <Cell value="土" style={saturday} />
  </tr>
);

export default DayOfWeek;
