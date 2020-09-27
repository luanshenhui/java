import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import moment from 'moment';

import Cell from './Cell';
import ViewHeader from './ViewHeader';

// cssのインポート
import styles from './MonthView.css';

export default class MonthView extends React.Component {
  constructor(props) {
    super(props);

    this.cellClick = this.cellClick.bind(this);
    this.next = this.next.bind(this);
    this.prev = this.prev.bind(this);
  }

  getMonth() {
    const month = this.props.date.month();
    return moment.monthsShort().map((item, i) => ({
      label: item,
      disabled: this.checkIfMonthDisabled(i),
      curr: i === month,
      id: `month${i}`,
    }));
  }

  // cellClick = (e) => {
  cellClick(e) {
    const month = e.target.innerHTML;
    if (this.checkIfMonthDisabled(month)) return;

    const date = this.props.date.clone().month(month);
    this.props.prevView(date);
  }

  checkIfMonthDisabled(month) {
    const now = this.props.date;
    return (
      now
        .clone()
        .month(month)
        .endOf('month')
        .isBefore(this.props.minDate, 'day') ||
      now
        .clone()
        .month(month)
        .startOf('month')
        .isAfter(this.props.maxDate, 'day')
    );
  }

  // next = () => {
  next() {
    let nextDate = this.props.date.clone().add(1, 'years');
    if (this.props.maxDate && nextDate.isAfter(this.props.maxDate, 'day')) {
      nextDate = this.props.maxDate;
    }
    this.props.setDate(nextDate);
  }

  // prev = () => {
  prev() {
    let prevDate = this.props.date.clone().subtract(1, 'years');
    if (this.props.minDate && prevDate.isBefore(this.props.minDate, 'day')) {
      prevDate = this.props.minDate;
    }
    this.props.setDate(prevDate);
  }

  render() {
    const currentDate = this.props.date.format('YYYY');
    const months = this.getMonth().map((item) => (
      <Cell
        className={classNames({
          [styles.month]: true,
          [styles.disabled]: item.disabled,
          [styles.current]: item.curr,
        })}
        key={item.id}
        value={item.label}
      />
    ));

    return (
      <div>
        <ViewHeader
          data={currentDate}
          next={this.next}
          prev={this.prev}
          titleAction={this.props.nextView}
        />
        <div className={styles.months} onClick={this.cellClick} role="presentation">
          {months}
        </div>
      </div>
    );
  }
}

MonthView.propTypes = {
  date: PropTypes.instanceOf(moment).isRequired,
  minDate: PropTypes.instanceOf(moment),
  maxDate: PropTypes.instanceOf(moment),
  prevView: PropTypes.func.isRequired,
  nextView: PropTypes.func.isRequired,
  setDate: PropTypes.func.isRequired,
};

MonthView.defaultProps = {
  minDate: null,
  maxDate: null,
};
