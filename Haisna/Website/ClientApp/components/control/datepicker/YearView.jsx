import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import moment from 'moment';

import Cell from './Cell';
import ViewHeader from './ViewHeader';

// cssのインポート
import styles from './YearView.css';

export default class YearsView extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      years: [],
    };

    this.cellClick = this.cellClick.bind(this);
    this.next = this.next.bind(this);
    this.prev = this.prev.bind(this);
  }

  componentWillMount() {
    this.getYears();
  }

  componentWillReceiveProps() {
    this.getYears();
  }

  getYears() {
    const now = this.props.date;
    const start = now.clone().subtract(5, 'year');
    const end = now.clone().add(6, 'year');
    const currYear = now.year();
    const inRange = this.rangeCheck(currYear);
    const items = [];

    const { years } = this.state;

    if (years.length > 0 && inRange) {
      return years;
    }

    const cal = start.clone();
    while (cal.isSameOrBefore(end, 'years')) {
      items.push({
        label: cal.format('YYYY'),
        disabled: this.checkIfYearDisabled(cal),
        curr: now.isSame(cal, 'years'),
        id: cal.format('YYYY'),
      });
      cal.add(1, 'years');
    }

    this.setState({ years: items });

    return items;
  }

  // cellClick = (e) => {
  cellClick(e) {
    const year = parseInt(e.target.innerHTML, 10);
    const date = this.props.date.clone().year(year);
    if (this.checkIfYearDisabled(date)) return;
    this.props.prevView(date);
  }

  checkIfYearDisabled(year) {
    return (
      year
        .clone()
        .endOf('year')
        .isBefore(this.props.minDate, 'day') ||
      year
        .clone()
        .startOf('year')
        .isAfter(this.props.maxDate, 'day')
    );
  }

  // next = () => {
  next() {
    let nextDate = this.props.date.clone().add(10, 'years');
    if (this.props.maxDate && nextDate.isAfter(this.props.maxDate, 'day')) {
      nextDate = this.props.maxDate;
    }
    this.props.setDate(nextDate);
  }

  // prev = () => {
  prev() {
    let prevDate = this.props.date.clone().subtract(10, 'years');
    if (this.props.minDate && prevDate.isBefore(this.props.minDate, 'day')) {
      prevDate = this.props.minDate;
    }
    this.props.setDate(prevDate);
  }

  rangeCheck(currYear) {
    const { years } = this.state;
    if (years.length === 0) {
      return false;
    }
    return years[0].label <= currYear && years[years.length - 1].label >= currYear;
  }

  render() {
    const { years } = this.state;
    const currYear = this.props.date.format('YYYY');
    const yearsCells = years.map((item) => (
      <Cell
        value={item.label}
        className={classNames({
          [styles.year]: true,
          [styles.disabled]: item.disabled,
          [styles.current]: item.label === currYear,
        })}
        key={item.id}
      />
    ));
    const currentDate = [years[0].label, years[years.length - 1].label].join('-');

    return (
      <div className={styles.yearsView}>
        <ViewHeader data={currentDate} next={this.next} prev={this.prev} />
        <div className={styles.years} onClick={this.cellClick} role="presentation">
          {yearsCells}
        </div>
      </div>
    );
  }
}

YearsView.propTypes = {
  date: PropTypes.instanceOf(moment).isRequired,
  minDate: PropTypes.instanceOf(moment),
  maxDate: PropTypes.instanceOf(moment),
  prevView: PropTypes.func.isRequired,
  setDate: PropTypes.func.isRequired,
};

YearsView.defaultProps = {
  minDate: null,
  maxDate: null,
};
