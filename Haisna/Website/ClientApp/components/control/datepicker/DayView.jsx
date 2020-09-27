import React from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';
import moment from 'moment';

import Cell from './Cell';

// cssのインポート
import styles from './DayView.css';

const daysTitles =
  [0, 1, 2, 3, 4, 5, 6].map((i) => ({
    label: moment()
      .weekday(i)
      .format('dd'),
    classes: {
      saturday: i === 6,
      sunday: i === 0,
    },
    id: `weekday${i}`,
  }));

export default class DayView extends React.Component {
  constructor(props) {
    super(props);

    this.cellClick = this.cellClick.bind(this);
  }

  getDays() {
    const { date } = this.props;
    const now = date || moment();
    const start = this.props.calDate
      .clone()
      .startOf('month')
      .weekday(0);
    const end = this.props.calDate
      .clone()
      .endOf('month')
      .weekday(6);
    const today = moment();
    const cal = start.clone();
    const days = [];

    while (cal.isSameOrBefore(end)) {
      days.push({
        label: cal.format('D'),
        classes: {
          saturday: cal.weekday() === 6,
          sunday: cal.weekday() === 0,
          current: cal.isSame(now, 'days') && cal.isSame(this.props.calDate, 'months'),
          prev: cal.isBefore(this.props.calDate, 'months'),
          next: cal.isAfter(this.props.calDate, 'months'),
          today: cal.isSame(today, 'days'),
        },
        id: `${this.props.calDate.format('YYYYMM')}-${cal.format('YYYYMMDD')}`,
      });
      cal.add(1, 'days');
    }
    return days;
  }

  // cellClick = (e) => {
  cellClick(e) {
    const cell = e.target;
    const date = parseInt(cell.innerHTML, 10);
    const newDate = this.props.calDate ? this.props.calDate.clone() : moment();

    if (Number.isNaN(date)) return;

    if (cell.className.indexOf('prev') > -1) {
      newDate.subtract(1, 'months');
    } else if (cell.className.indexOf('next') > -1) {
      newDate.add(1, 'months');
    }

    newDate.date(date);

    if (this.props.setDate) {
      this.props.setDate(newDate, true);
    }
  }

  render() {
    const titles = daysTitles.map((item) => (
      <Cell
        className={classNames(styles.day, {
          [styles.saturday]: item.classes.saturday,
          [styles.sunday]: item.classes.sunday,
          [styles.current]: item.classes.current,
          [styles.prev]: item.classes.prev,
          [styles.next]: item.classes.next,
          [styles.today]: item.classes.today,
        })}
        key={item.id}
        value={item.label}
      />
    ));
    const days = this.getDays().map((item) => (
      <Cell
        className={classNames(styles.day, {
          [styles.saturday]: item.classes.saturday,
          [styles.sunday]: item.classes.sunday,
          [styles.current]: item.classes.current,
          [styles.prev]: item.classes.prev,
          [styles.next]: item.classes.next,
          [styles.today]: item.classes.today,
        })}
        key={item.id}
        value={item.label}
      />
    ));

    return (
      <div className={styles.daysView}>
        <div className={styles.daysTitle}>{titles}</div>
        <div className={styles.days} onClick={this.cellClick} role="presentation">
          {days}
        </div>
      </div>
    );
  }
}

DayView.propTypes = {
  date: PropTypes.instanceOf(moment).isRequired,
  calDate: PropTypes.instanceOf(moment).isRequired,
  setDate: PropTypes.func,
};

DayView.defaultProps = {
  setDate: null,
};
