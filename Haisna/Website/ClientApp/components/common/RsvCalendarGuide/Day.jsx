/**
 * @file カレンダー検索ガイド用日付
 */
import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import Cell from './Cell';

import { RsvCalendarGuideStatus } from '../../../constants/common';

const sunday = {
  color: '#f00',
};
const saturday = {
  color: '#06f',
};
const past = {
  backgroundColor: '#ffffff',
};
const normal = {
  backgroundColor: '#afeeee',
};
const over = {
  backgroundColor: '#ff6347',
};
const full = {
  backgroundColor: '#ff6347',
};
const noRsvfra = {
  backgroundColor: '#ffcccc',
};
const noContract = {
  backgroundColor: '#cccccc',
};
const holiday = {
  backgroundColor: '#90ee90',
};

const Day = (props) => {
  const { date, year, month, onSelected, schedule, isSelectable } = props;

  const isView = (date.format('YYYY') === year && date.format('M') === month);
  const value = isView ? date.format('D') : '';

  let handleClick = () => onSelected(date.format('YYYY/MM/DD'));
  let style = {};
  if (isView) {
    if (date.day() === 0) {
      style = { ...style, ...sunday };
    }

    if (date.day() === 6) {
      style = { ...style, ...saturday };
    }

    const dateSchedule = schedule.filter((rec) => moment(rec.csldate).isSame(date, 'day'))[0];
    if (dateSchedule) {
      // 日付カラー設定
      switch (dateSchedule.status) {
        case RsvCalendarGuideStatus.Past:
          style = { ...style, ...past };
          break;
        case RsvCalendarGuideStatus.Normal:
          style = { ...style, ...(dateSchedule.holiday !== null ? noRsvfra : normal) };
          break;
        case RsvCalendarGuideStatus.Over:
          style = { ...style, ...(dateSchedule.holiday !== null ? noRsvfra : over) };
          break;
        case RsvCalendarGuideStatus.Full:
          style = { ...style, ...(dateSchedule.holiday !== null ? noRsvfra : full) };
          break;
        case RsvCalendarGuideStatus.NoRsvfra:
          style = { ...style, ...noRsvfra };
          break;
        case RsvCalendarGuideStatus.NoContract:
          style = { ...style, ...noContract };
          break;
        default:
          style = { ...style, ...(dateSchedule.holiday !== null ? noRsvfra : normal) };
      }

      // アンカーの有無
      if (!isSelectable(dateSchedule)) {
        handleClick = undefined;
      }
    }
  }

  return (
    <Cell
      value={value}
      onClick={handleClick}
      style={style}
    />
  );
};

Day.propTypes = {
  date: PropTypes.instanceOf(moment).isRequired,
  year: PropTypes.string.isRequired,
  month: PropTypes.string.isRequired,
  onSelected: PropTypes.func,
  schedule: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  isSelectable: PropTypes.func.isRequired,
};

Day.defaultProps = {
  onSelected: undefined,
};

export default Day;
