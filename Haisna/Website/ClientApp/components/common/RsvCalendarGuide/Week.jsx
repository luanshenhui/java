/**
 * @file カレンダー検索ガイド用カレンダー行
 */
import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import Day from './Day';

const Week = (props) => {
  const { startDate } = props;
  return (
    <tr>
      {
        Array.from({ length: 7 }, (_, i) => (
          <Day
            {...props}
            key={`day${i}`}
            date={startDate.clone().add(i, 'days')}
          />
        ))
      }
    </tr>
  );
};

Week.propTypes = {
  startDate: PropTypes.instanceOf(moment).isRequired,
};

export default Week;
