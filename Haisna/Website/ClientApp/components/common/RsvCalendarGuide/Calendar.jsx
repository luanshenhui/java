/**
 * @file カレンダー検索ガイド用カレンダー
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';

import Week from './Week';
import DayOfWeek from './DayOfWeek';
import Caption from './Caption';

const Table = styled.table`
  width: 400px;
  height: 300px;
  border: 1px solid #000;
`;

const Calendar = (props) => {
  const { year, month } = props;

  const startDate = moment(`${year}/${month}/1`, 'YYYY/MM/DD').startOf('week');

  return (
    <Table>
      <tbody>
        <Caption year={year} month={month} />
        <DayOfWeek />
        { Array.from({ length: 6 }, (_, i) => (
          <Week
            {...props}
            key={`Week${i}`}
            startDate={startDate.clone().add(7 * i, 'days')}
          />
        ))}
      </tbody>
    </Table>
  );
};

Calendar.propTypes = {
  year: PropTypes.string,
  month: PropTypes.string,
};

Calendar.defaultProps = {
  year: '',
  month: '',
};

export default Calendar;
