import React from 'react';
import PropTypes from 'prop-types';

import moment from 'moment';

import ViewHeader from './ViewHeader';
import DayView from './DayView';

export default class DayViews extends React.Component {
  constructor(props) {
    super(props);

    this.next = this.next.bind(this);
    this.prev = this.prev.bind(this);
  }

  // next = () => {
  next() {
    let nextDate = this.props.date.clone().add(1, 'months');
    if (this.props.maxDate && nextDate.isAfter(this.props.maxDate, 'day')) {
      nextDate = this.props.maxDate;
    }
    if (this.props.setDate) {
      this.props.setDate(nextDate);
    }
  }

  // prev = () => {
  prev() {
    let prevDate = this.props.date.clone().subtract(1, 'months');
    if (this.props.minDate && prevDate.isBefore(this.props.minDate, 'day')) {
      prevDate = this.props.minDate;
    }
    if (this.props.setDate) {
      this.props.setDate(prevDate);
    }
  }

  render() {
    const lastDate = this.props.date.clone().subtract(1, 'months');
    const nextDate = this.props.date.clone().add(1, 'months');

    const currentDate = this.props.date ? this.props.date.format('YYYY年M月') : moment().format('YYYY年M月');

    return (
      <div>
        <ViewHeader
          data={currentDate}
          next={this.next}
          prev={this.prev}
          titleAction={this.props.nextView}
        />
        <div>
          <DayView setDate={this.props.setDate} date={this.props.date} calDate={lastDate} />
          <DayView setDate={this.props.setDate} date={this.props.date} calDate={this.props.date} />
          <DayView setDate={this.props.setDate} date={this.props.date} calDate={nextDate} />
        </div>
      </div>
    );
  }
}

DayViews.propTypes = {
  date: PropTypes.instanceOf(moment).isRequired,
  minDate: PropTypes.instanceOf(moment),
  maxDate: PropTypes.instanceOf(moment),
  setDate: PropTypes.func.isRequired,
  nextView: PropTypes.func,
};

DayViews.defaultProps = {
  minDate: null,
  maxDate: null,
  setDate: null,
  nextView: null,
};
